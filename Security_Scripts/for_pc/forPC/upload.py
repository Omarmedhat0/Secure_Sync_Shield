import os
import hashlib
import logging
import firebase_admin
from firebase_admin import credentials, storage, db
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import padding as sym_padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

# Initialize logging
logging.basicConfig(filename='upload_log.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def log_info(message):
    logging.info(message)
    print(message)

def log_error(message):
    logging.error(message)
    print(message)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("/home/muhammed/myworkspace/GP/Server/Scripts/firebase-adminsdk.json")
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
    try:
        log_info(f"Loading RSA public key from {public_key_path}")
        with open(public_key_path, "rb") as public_file:
            public_key = serialization.load_pem_public_key(
                public_file.read(),
                backend=default_backend()
            )
        log_info("RSA public key loaded successfully")
        return public_key
    except Exception as e:
        log_error(f"Error loading RSA public key: {e}")
        raise

def load_rsa_private_key(private_key_path):
    """Load an RSA private key from a PEM file."""
    try:
        log_info(f"Loading RSA private key from {private_key_path}")
        with open(private_key_path, "rb") as private_file:
            private_key = serialization.load_pem_private_key(
                private_file.read(),
                password=None,
                backend=default_backend()
            )
        log_info("RSA private key loaded successfully")
        return private_key
    except Exception as e:
        log_error(f"Error loading RSA private key: {e}")
        raise

def aes_encrypt(plaintext, key, iv):
    """Encrypt plaintext using AES (CBC mode) with the given key and IV."""
    try:
        log_info("Starting AES encryption")
        cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
        encryptor = cipher.encryptor()

        # Add padding to the plaintext
        padder = sym_padding.PKCS7(algorithms.AES.block_size).padder()
        padded_plaintext = padder.update(plaintext) + padder.finalize()

        # Encrypt the padded plaintext
        ciphertext = encryptor.update(padded_plaintext) + encryptor.finalize()
        log_info("AES encryption completed successfully")
        return ciphertext
    except Exception as e:
        log_error(f"Error during AES encryption: {e}")
        raise

def rsa_encrypt(aes_key, public_key):
    """Encrypt the AES key using RSA and the given public key."""
    try:
        log_info("Starting RSA encryption of the AES key")
        encrypted_key = public_key.encrypt(
            aes_key,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )
        log_info("RSA encryption of AES key completed successfully")
        return encrypted_key
    except Exception as e:
        log_error(f"Error during RSA encryption: {e}")
        raise

def sign_data(data, private_key):
    """Sign the data using RSA private key."""
    try:
        log_info("Starting data signing")
        signature = private_key.sign(
            data,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        log_info("Data signing completed successfully")
        return signature
    except Exception as e:
        log_error(f"Error during data signing: {e}")
        raise

def hybrid_encrypt(file_path, public_key_path, private_key_path, encrypted_file_path):
    """Encrypt a file using hybrid encryption (AES for content, RSA for AES key) and sign it."""
    try:
        # Load the RSA public key
        public_key = load_rsa_public_key(public_key_path)
        
        # Load the RSA private key for signing
        private_key = load_rsa_private_key(private_key_path)

        # Generate AES key and IV
        aes_key, iv = generate_aes_key()

        # Read the file content
        with open(file_path, "rb") as file:
            plaintext = file.read()

        # Encrypt the file content using AES
        ciphertext = aes_encrypt(plaintext, aes_key, iv)

        # Encrypt the AES key using RSA
        encrypted_key = rsa_encrypt(aes_key, public_key)

        # Concatenate the encrypted AES key, IV, and ciphertext for signing
        data_to_sign = encrypted_key + iv + ciphertext

        # Sign the concatenated data
        signature = sign_data(data_to_sign, private_key)

        # Save the encrypted AES key, IV, ciphertext, and signature to the output file
        with open(encrypted_file_path, "wb") as file:
            file.write(encrypted_key)
            file.write(iv)
            file.write(signature)
            file.write(ciphertext)
        
        log_info(f"File {file_path} encrypted and signed successfully")
    except Exception as e:
        log_error(f"Error during hybrid encryption: {e}")
        raise

def save_hex_file_to_firebase(local_file_path, remote_file_name):
    """Uploads a file to Firebase Storage."""
    try:
        log_info(f"Starting upload of {local_file_path} to Firebase Storage as {remote_file_name}")
        blob = bucket.blob(remote_file_name)
        blob.upload_from_filename(local_file_path)
        log_info(f"File {remote_file_name} uploaded successfully to Firebase Storage")
    except Exception as e:
        log_error(f"Error uploading file to Firebase Storage: {e}")
        raise

def calculate_md5(file_path):
    """Calculate the MD5 checksum of a file."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def main():
    # File paths
    local_file_path = r"/home/muhammed/myworkspace/GP/Server/FilesToUpload/test.txt"
    encrypted_file_path = r"/home/muhammed/myworkspace/GP/Server/FilesToUpload/test_encrypted.txt"
    public_key_path = r"/home/muhammed/myworkspace/GP/Server/Scripts/Sec_Keys/publicKeyRasPi.pem"
    private_key_path = r"/home/muhammed/myworkspace/GP/Server/Scripts/Sec_Keys/privateKeyPC.pem"
    remote_file_name = "test.txt"

    try:
        # Encrypt the file
        hybrid_encrypt(local_file_path, public_key_path, private_key_path, encrypted_file_path)
        log_info(f"File {local_file_path} encrypted successfully")

        # Upload the encrypted file to Firebase Storage
        save_hex_file_to_firebase(encrypted_file_path, remote_file_name)

        # Set the update flag in the database
        db.reference('update_flag').set(True)
        log_info("Update flag set to True in the database")

        # Log checksums for verification
        original_checksum = calculate_md5(local_file_path)
        encrypted_checksum = calculate_md5(encrypted_file_path)
        log_info(f"Original file checksum: {original_checksum}")
        log_info(f"Encrypted file checksum: {encrypted_checksum}")

    except Exception as e:
        log_error(f"Unexpected error: {e}")
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()

