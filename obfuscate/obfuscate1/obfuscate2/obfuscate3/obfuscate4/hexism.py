import os

def pad_file_to_size(file_path, target_size):
    # Check if the file already exceeds the target size
    if os.path.getsize(file_path) >= target_size:
        print("File size already exceeds target size.")
        return

    # Open the file in append mode and seek to the end
    with open(file_path, 'ab') as f:
        current_size = f.tell()

        # Calculate the number of bytes needed to reach the target size
        remaining_size = target_size - current_size
        padding = b'\x00' * remaining_size

        # Append the padding bytes to the file
        f.write(padding)
        print("File padded successfully.")

# Usage example
file_path = "hatasiz2.exe"
target_size = 655 * 1024 * 1024  # 655 MB in bytes
pad_file_to_size(file_path, target_size)