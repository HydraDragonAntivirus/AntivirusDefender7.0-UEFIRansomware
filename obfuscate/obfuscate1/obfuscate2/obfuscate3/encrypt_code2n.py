#!/usr/bin/env python
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad
import base64

class Encrypt:
    def __init__(self):
        self.YELLOW, self.GREEN = '\33[93m',  '\033[1;32m'
        self.text = ""
        self.enc_txt = ""

    def generate_key_iv(self):
        key = get_random_bytes(32)  # 256-bit anahtar
        iv = get_random_bytes(16)   # 128-bit IV
        return key, iv

    def encrypt_text(self, text, key, iv):
        cipher = AES.new(key, AES.MODE_CBC, iv)
        ciphertext = cipher.encrypt(pad(text.encode(), AES.block_size))
        return base64.b64encode(iv + ciphertext)

    def encrypt(self, filename):
        print(f"\n{self.YELLOW}[*] Encrypting Source Codes...")
        with open(filename, "r") as f:
            lines_list = f.readlines()
            for lines in lines_list:
                self.text += lines
              
            key, iv = self.generate_key_iv()
            self.enc_txt = self.encrypt_text(self.text, key, iv)   

        with open(filename, "w") as f:
            f.write(f"from Crypto.Cipher import AES\nfrom Crypto.Util.Padding import unpad\nimport base64\n\ndef decrypt_text(encrypted_text, key):\n    encrypted_text = base64.b64decode(encrypted_text)\n    iv = encrypted_text[:16]\n    ciphertext = encrypted_text[16:]\n    cipher = AES.new(key, AES.MODE_CBC, iv)\n    decrypted_text = unpad(cipher.decrypt(ciphertext), AES.block_size)\n    return decrypted_text.decode()\n\nkey = {key}\n\nexec(decrypt_text({self.enc_txt}, key))")
            
        print(f"{self.GREEN}[+] Operation Completed Successfully!\n")
    
if __name__ == '__main__':   
    test = Encrypt()
    filename = input("Please Enter Filename: ")
    test.encrypt(filename)
