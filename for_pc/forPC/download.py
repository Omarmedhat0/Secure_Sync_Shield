import os
import time
import hashlib
import logging
import firebase_admin
from firebase_admin import credentials, storage
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import padding as sym_padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.exceptions import InvalidSignature, InvalidKey

# Initialize logging
logging.basicConfig(filename='download_log.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def log_info(message):
    logging.info(message)
    print(message)

def log_error(message):
    logging.error(message)
    print(message)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("/home/muhammed/myworkspace/GP/Server/Scripts/firebase-adminsdk.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "iti-gp-sss.appspot.com"
})

bucket = storage.bucket()

def load_rsa_private_key(private_key_path):
    """Load an RSA private key from a PEM file."""
    try:
        #log_info(f"Loading RSA private key from {private_key_path}")
        with open(private_key_path, "rb") as private_file:
            private_key = serialization.load_pem_private_key(
                private_file.read(),
                password=None,
                backend=default_backend()
            )
        #log_info("RSA private key loaded successfully")
        return private_key
    except Exception as e:
        log_error(f"Error loading RSA private key: {e}")
        raise

def aes_decrypt(ciphertext, key, iv):
    """Decrypt ciphertext using AES (CBC mode) with the given key and IV."""
    try:
        log_info("Starting AES decryption")
        cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
        decryptor = cipher.decryptor()
        plaintext = decryptor.update(ciphertext) + decryptor.finalize()
        
        # Remove PKCS7 padding
        unpadder = sym_padding.PKCS7(algorithms.AES.block_size).unpadder()
        unpadded_plaintext = unpadder.update(plaintext) + unpadder.finalize()
        
        #log_info("AES decryption completed successfully")
        return unpadded_plaintext
    except ValueError as e:
        log_error(f"Invalid padding bytes: {e}. Decryption failed.")
        raise
    except Exception as e:
        log_error(f"Error during AES decryption: {e}")
        raise

def rsa_decrypt(encrypted_key, private_key):
    """Decrypt the AES key using RSA and the given private key."""
    try:
        log_info("Starting RSA decryption of the AES key")
        aes_key = private_key.decrypt(
            encrypted_key,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )
        #log_info(f"RSA decryption of AES key completed: {aes_key.hex()}")
        return aes_key
    except Exception as e:
        log_error(f"Error during RSA decryption: {e}")
        raise

def verify_signature(data, signature, public_key_path):
    """Verify the data signature using the RSA public key."""
    try:
        #log_info(f"Loading RSA public key from {public_key_path}")
        with open(public_key_path, "rb") as public_file:
            public_key = serialization.load_pem_public_key(
                public_file.read(),
                backend=default_backend()
            )
        #log_info("RSA public key loaded successfully")
        
        #log_info("Starting signature verification")
        public_key.verify(
            signature,
            data,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        log_info("Signature verification succeeded")
    except InvalidSignature as e:
        log_error(f"Signature verification failed: {e}")
        raise
    except Exception as e:
        log_error(f"Error during signature verification: {e}")
        raise

def hybrid_decrypt(input_file_path, private_key_path, public_key_path, output_file_path):
    """Decrypt a file using hybrid encryption (AES for content, RSA for AES key) and verify the signature."""
    log_info("Decrypting file...")

    private_key = load_rsa_private_key(private_key_path)

    with open(input_file_path, "rb") as file:
        encrypted_key = file.read(256)  # RSA key size
        iv = file.read(16)
        signature = file.read(256)  # Assuming the RSA signature size
        ciphertext = file.read()

    # Decrypt the AES key with RSA
    key = rsa_decrypt(encrypted_key, private_key)

    # Verify the signature
    verify_signature(encrypted_key + iv + ciphertext, signature, public_key_path)

    # Decrypt the file content with AES
    plaintext = aes_decrypt(ciphertext, key, iv)

    # Backup the existing decrypted file, if any
    if os.path.exists(output_file_path):
        backup_file_path = output_file_path + ".backup"
        os.rename(output_file_path, backup_file_path)
        log_info(f"Existing file backed up")

    # Save decrypted content to the output file
    with open(output_file_path, "wb") as file:
        file.write(plaintext)

    log_info(f"File decrypted and saved successfully")

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
    public_key_path = os.path.expanduser("~/myworkspace/GP/Server/Scripts/Sec_Keys/publicKeyPC.pem")
    
    try:
        blob = bucket.blob("test.txt")
        
        # Download the file to a temporary location to calculate its checksum
        temp_download_path = os.path.expanduser("~/myworkspace/GP/Server/DownloadedFiles/temp_test.txt")
        blob.download_to_filename(temp_download_path)
        
        # Calculate the MD5 checksum of the downloaded file
        server_checksum = calculate_md5(temp_download_path)
        #log_info(f"Server file checksum: {server_checksum}")
        
        # Calculate MD5 checksum of the local file, if it exists
        if os.path.exists(encrypted_file_path):
            local_checksum = calculate_md5(encrypted_file_path)
            #log_info(f"Local file checksum: {local_checksum}")
        else:
            local_checksum = None
            log_info("Local file does not exist. Will download new file.")

        # Compare checksums to determine if the file has changed
        if local_checksum != server_checksum:
            log_info("File on server has changed. Downloading new version...")
            # Replace the local file with the new version from the server
            os.replace(temp_download_path, encrypted_file_path)
            #log_info(f"File downloaded successfully to {encrypted_file_path}")
            #log_info(f"File details: {os.stat(encrypted_file_path)}")
            # Decrypt the file
            hybrid_decrypt(encrypted_file_path, private_key_path, public_key_path, decrypted_file_path)
        else:
            log_info("File on server has not changed. Skipping download.")
            # Remove the temporary download
            os.remove(temp_download_path)
    except Exception as e:
        log_error(f"Error downloading or decrypting file: {e}")

def main():
    log_info("=====================================")
    log_info("Starting download and decryption loop")
    try:
        while True:
            # Download and decrypt the file
            download_and_decrypt_file()
            # Sleep for some time before repeating
            time.sleep(20)  # Sleep for 20 seconds (adjust as needed)
    except KeyboardInterrupt:
        log_info("Script stopped by user")
    except Exception as e:
        log_error(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()

