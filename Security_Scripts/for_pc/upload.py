import os
from google.cloud import storage
from google.oauth2 import service_account
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import padding as sym_padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import firebase_admin
from firebase_admin import credentials, db, storage



# Initialize Firebase Admin SDK
cred = credentials.Certificate(r"/home/muhammed/myworkspace/GP/Server/Scripts/firebase-adminsdk.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "iti-gp-sss.appspot.com",
    "databaseURL": "https://iti-gp-sss.firebaseio.com"
})

bucket = storage.bucket()

def generate_aes_key():
    """Generate a random AES key and IV (initialization vector)."""
    key = os.urandom(32)  # 256-bit key for AES-256
    iv = os.urandom(16)   # 128-bit IV
    return key, iv

def load_rsa_public_key(public_key_path):
    """Load an RSA public key from a PEM file."""
    with open(public_key_path, "rb") as public_file:
        public_key = serialization.load_pem_public_key(
            public_file.read(),
            backend=default_backend()
        )
    return public_key

def aes_encrypt(plaintext, key, iv):
    """Encrypt plaintext using AES (CBC mode) with the given key and IV."""
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()

    # Add padding to the plaintext
    padder = sym_padding.PKCS7(algorithms.AES.block_size).padder()
    padded_plaintext = padder.update(plaintext) + padder.finalize()

    # Encrypt the padded plaintext
    ciphertext = encryptor.update(padded_plaintext) + encryptor.finalize()
    return ciphertext


def rsa_encrypt(aes_key, public_key):
    """Encrypt the AES key using RSA and the given public key."""
    encrypted_key = public_key.encrypt(
        aes_key,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return encrypted_key

def hybrid_encrypt(file_path, public_key_path, encrypted_file_path):
    """Encrypt a file using hybrid encryption (AES for content, RSA for AES key)."""
    # Load the RSA public key
    public_key = load_rsa_public_key(public_key_path)
    
    # Generate AES key and IV
    aes_key, iv = generate_aes_key()

    # Read the file content
    with open(file_path, "rb") as file:
        plaintext = file.read()

    # Encrypt the file content using AES
    ciphertext = aes_encrypt(plaintext, aes_key, iv)

    # Encrypt the AES key using RSA
    encrypted_key = rsa_encrypt(aes_key, public_key)

    # Save the encrypted AES key, IV, and ciphertext to the output file
    with open(encrypted_file_path, "wb") as file:
        file.write(encrypted_key)
        file.write(iv)
        file.write(ciphertext)

def save_hex_file_to_firebase(local_file_path, remote_file_name):
    """Uploads a file to Firebase Storage."""
    try:
        blob = bucket.blob(remote_file_name)
        blob.upload_from_filename(local_file_path)
        print(f"File {remote_file_name} uploaded successfully to Firebase Storage")
    except Exception as e:
        print(f"Error uploading file to Firebase Storage: {e}")

def main():
    # File paths
    local_file_path = r"/home/muhammed/myworkspace/GP/Server/FilesToUpload/test.txt"
    encrypted_file_path = r"/home/muhammed/myworkspace/GP/Server/FilesToUpload/test_encrypted.txt"
    public_key_path = r"/home/muhammed/myworkspace/GP/Server/Scripts/Sec_Keys/publicKeyRasPi.pem"
    remote_file_name = "test.txt"

    try:
        # Encrypt the file
        hybrid_encrypt(local_file_path, public_key_path, encrypted_file_path)
        print(f"File {local_file_path} encrypted successfully")

        # Upload the encrypted file to Firebase Storage
        save_hex_file_to_firebase(encrypted_file_path, remote_file_name)

        # Set the update flag in the database
        db.reference('update_flag').set(True)

    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()

