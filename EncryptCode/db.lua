local bit32 = require("bit32")

local function to_bytes(str)
    local bytes = {}
    for i = 1, #str do
        table.insert(bytes, str:byte(i))
    end
    return bytes
end

local function to_string(bytes)
    local chars = {}
    for i = 1, #bytes do
        table.insert(chars, string.char(bytes[i]))
    end
    return table.concat(chars)
end

local function to_hex(bytes)
    local hex = {}
    for i = 1, #bytes do
        table.insert(hex, string.format("%02x", bytes[i]))
    end
    return table.concat(hex)
end

local function from_hex(hex)
    local bytes = {}
    for i = 1, #hex, 2 do
        table.insert(bytes, tonumber(hex:sub(i, i+1), 16))
    end
    return bytes
end

function encrypt(text, key)
    local encrypted = {}
    local text_bytes = to_bytes(text)
    local key_bytes = to_bytes(key)
    for i = 1, #text_bytes do
        local key_byte = key_bytes[(i - 1) % #key_bytes + 1]
        table.insert(encrypted, bit32.bxor(text_bytes[i], key_byte))
    end
    return to_hex(encrypted)
end

function decrypt(encrypted_text, key)
    local encrypted_bytes = from_hex(encrypted_text)
    local decrypted = {}
    local key_bytes = to_bytes(key)
    for i = 1, #encrypted_bytes do
        local key_byte = key_bytes[(i - 1) % #key_bytes + 1]
        table.insert(decrypted, bit32.bxor(encrypted_bytes[i], key_byte))
    end
    return to_string(decrypted)
end

local originalText = string.format("Hello World my name is %s and I'm %d years old", "John", 30)
local key = string.format("my_secret_key_%s", math.random(1, 1000))

local encryptedText = encrypt(originalText, key)
print("Encrypt code: " .. encryptedText)

local decryptedText = decrypt(encryptedText, key)
print("Decrypt code: " .. decryptedText)
