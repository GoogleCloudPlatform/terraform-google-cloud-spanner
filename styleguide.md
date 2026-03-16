# Engineering Team: Pull Request Review Checklist

This document outlines the core principles and standards that Gemini Code Assist should enforce during automated pull request reviews.

---

### ✅ **1. Code Functionality & Correctness**
- **Error Handling:** All potential errors must be handled gracefully. Code should not crash on unexpected input. Ensure `try...catch` blocks are used for operations that can fail.
- **No Magic Numbers:** All constant values must be defined as named constants. Do not use hardcoded numbers directly in the code.
- **API Contracts:** For any changes to an API endpoint, ensure the corresponding documentation (e.g., Swagger or OpenAPI docs) is also updated in the same PR.

---

### ✅ **2. Readability & Maintainability**
- **Function Documentation:** All public functions and methods must have a clear docstring explaining their purpose, parameters, and return value.
- **Variable Naming:** Variable names must be descriptive and use `camelCase`. Avoid single-letter variable names except for simple loop counters.
- **Function Length:** Functions should not exceed 50 lines of code. If a function is longer, it should be broken down into smaller, more manageable helper functions.

---

### ✅ **3. Security**
- **No Hardcoded Secrets:** Ensure no API keys, passwords, or other secrets are hardcoded in the source code. These must be loaded from environment variables or a secure vault.
- **Input Validation:** All user-provided input must be sanitized and validated to prevent injection attacks (e.g., SQL injection, XSS).

---

### ✅ **4. Testing**
- **Unit Test Coverage:** All new features and bug fixes must be accompanied by corresponding unit tests.
- **Test Naming:** Test descriptions should clearly state what is being tested. For example, `it('should return an error when the user is not found')`.

