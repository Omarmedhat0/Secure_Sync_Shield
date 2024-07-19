import os
import time
import logging
import firebase_admin
import hashlib
from firebase_admin import credentials, storage
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.padding import PKCS7
from cryptography.hazmat.backends import default_backend
from cryptography.exceptions import InvalidSignature

# Initialize Firebase Admin SDK
cred = credentials.Certificate("/home/muhammed/myworkspace/GP/Server/Scripts/firebase-adminsdk.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "iti-gp-sss.appspot.com"
})

# Get a reference to the Firebase Storage bucket
bucket = storage.bucket()

# Set up logging
log_file_path = os.path.expanduser("~/myworkspace/GP/Server/DownloadedFiles/log.txt")
logging.basicConfig(
    filename=log_file_path,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

def log_info(message):
    logging.info(message)
    print(message)

def log_error(message):
    logging.error(message)
    print(message)

def load_rsa_private_key(private_key_path):
    """Load an RSA private key from a PEM file."""
    with open(private_key_path, "rb") as private_file:
        private_key = serialization.load_pem_private_key(
            private_file.read(),
            password=None,
            backend=default_backend()
        )
    return private_key

def aes_decrypt(ciphertext, key, iv):
    """Decrypt ciphertext using AES (CBC mode) with the given key and IV."""
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    plaintext = decryptor.update(ciphertext) + decryptor.finalize()
    
    # Remove PKCS7 padding
    unpadder = PKCS7(algorithms.AES.block_size).unpadder()
    unpadded_plaintext = unpadder.update(plaintext) + unpadder.finalize()
    
    return unpadded_plaintext

def rsa_decrypt(encrypted_key, private_key):
    """Decrypt the AES key using RSA and the given private key."""
    aes_key = private_key.decrypt(
        encrypted_key,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return aes_key

def hybrid_decrypt(input_file_path, private_key_path, output_file_path):
    """Decrypt a file using hybrid encryption (AES for content, RSA for AES key)."""
    log_info("Decrypting file...")

    private_key = load_rsa_private_key(private_key_path)

    with open(input_file_path, "rb") as file:
        encrypted_key = file.read(256)  # RSA key size
        iv = file.read(16)
        ciphertext = file.read()

    # Decrypt the AES key with RSA
    key = rsa_decrypt(encrypted_key, private_key)

    # Decrypt the file content with AES
    plaintext = aes_decrypt(ciphertext, key, iv)

    # Backup the existing decrypted file, if any
    if os.path.exists(output_file_path):
        backup_file_path = output_file_path + ".backup"
        os.rename(output_file_path, backup_file_path)
        log_info(f"Existing file backed up as: {backup_file_path}")

    # Save decrypted content to the output file
    with open(output_file_path, "wb") as file:
        file.write(plaintext)

    log_info(f"File decrypted and saved to {output_file_path}")

def calculate_md5(file_path):
    """Calculate the MD5 checksum of a file."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def download_and_decrypt_file():
    """Download an encrypted file from Firebase Storage and decrypt it."""
    encrypted_file_path = os.path.expanduser("~/myworkspace/GP/Server/DownloadedFiles/test.txt")
    decrypted_file_path = os.path.expanduser("~/myworkspace/GP/Server/DownloadedFiles/test_decrypted.txt")
    private_key_path = os.path.expanduser("~/myworkspace/GP/Server/Scripts/Sec_Keys/privateKeyRasPi.pem")
    
    try:
        blob = bucket.blob("test.txt")
        
        # Download the file to a temporary location to calculate its checksum
        temp_download_path = os.path.expanduser("~/myworkspace/GP/Server/DownloadedFiles/temp_test.txt")
        blob.download_to_filename(temp_download_path)
        
        # Calculate the MD5 checksum of the downloaded file
        server_checksum = calculate_md5(temp_download_path)
        
        # Calculate MD5 checksum of the local file, if it exists
        if os.path.exists(encrypted_file_path):
            local_checksum = calculate_md5(encrypted_file_path)
        else:
            local_checksum = None

        # Compare checksums to determine if the file has changed
        if local_checksum != server_checksum:
            log_info("File on server has changed. Downloading new version...")
            # Replace the local file with the new version from the server
            os.replace(temp_download_path, encrypted_file_path)
            log_info(f"File downloaded successfully to {encrypted_file_path}")
            # Decrypt the file
            hybrid_decrypt(encrypted_file_path, private_key_path, decrypted_file_path)
        else:
            log_info("File on server has not changed. Skipping download.")
            # Remove the temporary download
            os.remove(temp_download_path)
    except Exception as e:
        log_error(f"Error downloading or decrypting file: {e}")

def main():
    try:
        while True:
            # Download and decrypt the file
            download_and_decrypt_file()
            # Sleep for some time before repeating
            time.sleep(20)  # Sleep for 60 seconds (adjust as needed)
    except KeyboardInterrupt:
        log_info("Script stopped by user")
    except Exception as e:
        log_error(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()

