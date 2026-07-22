import numpy as np
from numpy.linalg import inv
import string

ALPHABET = " " + string.ascii_uppercase
CHAR_TO_INDEX = {ch: i for i, ch in enumerate(ALPHABET)}
INDEX_TO_CHAR = {i: ch for i, ch in enumerate(ALPHABET)}

def convert_text_to_vector(text):
    k = 27
    indices = [CHAR_TO_INDEX[ch] for ch in text]
    mat = np.zeros((len(indices), k), dtype=int)
    for i, idx in enumerate(indices):
        mat[i, idx] = 1
    return mat

def convert_vector_to_text(matrix):
    indexes = np.argmax(matrix, axis=1)
    text = ''.join(INDEX_TO_CHAR[idx] for idx in indexes)
    return text

def generate_keys(n=27):
    G = np.eye(n, dtype=int)

    perm = np.random.permutation(n)

    P = np.zeros((n, n), dtype=int)
    for r in range(n):
        P[r, perm[r]] = 1

    public_G = (G @ P) % 2

    return public_G, (G, P)

def encrypt(plaintext, public_key):
    M = convert_text_to_vector(plaintext)
    ciphertext = (M @ public_key) % 2
    return ciphertext

def decrypt(ciphertext, private_key):
    G, P = private_key
    inv_P = inv(P).astype(int) % 2

    decode_matrix = (ciphertext @ inv_P) % 2
    return convert_vector_to_text(decode_matrix)

if __name__ == "__main__":
    public_key, private_key = generate_keys()

    plaintext = "HELLO WORLD"

    encrypted_text = encrypt(plaintext, public_key)
    print("Ciphertext:\n", encrypted_text)

    decrypted_text = decrypt(encrypted_text, private_key)
    print("Decrypted Text:", decrypted_text)
