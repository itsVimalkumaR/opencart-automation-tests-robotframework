# 🧪 OpenCart Application Automation Tests – Robot Framework

Automated **UI and API testing** for the OpenCart demo site using **Robot Framework**. This test suite covers core e-commerce flows including user login, product search, checkout, and more. It follows the **Page Object Model** (POM) and uses tools like `SeleniumLibrary` and `RequestsLibrary`.

---

## 📌 Key Functionalities Covered

Test scenarios include but are not limited to:

- 🔐 **Authentication**
  - Register
  - Login
  - Logout
  - Forgot Password

- 🏠 **Home & Navigation**
  - Search
  - Product Display
  - Product Comparison
  - Add to Cart
  - Wish List

- 💳 **Checkout & Orders**
  - Shopping Cart
  - Checkout
  - Order History
  - Downloads
  - Recurring Payments
  - Returns

- 👤 **My Account**
  - Change Password
  - Account Info
  - Address Book

- 🛍 **Product Features**
  - Special Offers
  - Gift Certificate
  - Reward Points
  - Affiliate
  - Newsletter

- 🌍 **Other**
  - Contact Us
  - Currencies
  - Header/Footer menu validations

_Total: 34 Functional Scenarios with over 500 test cases._

---

# 🚀 Getting Started

---

## 🚀 Introduction

This project outlines a complete Robot Framework-based automation solution for OpenCart and POS systems. It includes:

- Web UI testing (SeleniumLibrary)
- API testing (RequestsLibrary / RESTinstance)
- Cross-browser testing
- Database validation
- CI/CD integration support (Jenkins, GitLab)
- Parallel test execution with Pabot
- Modular design with Page Object Model for easy maintenance

> **Tech Stack:** 
> Robot Framework | Python 3.11+ | Selenium | Page Object Model | RESTinstance | WebDriverManager | Pabot

---

## 🛠️ Tech Stack
| Category       | Tools/Libraries         |
|----------------|-------------------------|
| **Core**       | Robot Framework, Python 3.11+ |
| **Web Testing**| SeleniumLibrary, BrowserStack |
| **API Testing**| RequestsLibrary, RESTinstance |
| **Utilities**  | Faker, WebDriverManager |
| **CI/CD**      | Jenkins, GitLab CI      |

---

## 🛠️ Prerequisites

Before running the test automation, install the following:

### 1. Required Software

   - **PyCharm IDE** *(recommended)* → [Download](https://www.jetbrains.com/pycharm/download/)
   - **JDK 17+** → [Download](https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe)
   - **Python 3.11+** → [Download](https://www.python.org/downloads/)


### 2. Clone the repository

```bash
git clone https://github.com/<your-org-name>/opencart_automation-tests-robotframework.git
cd opencart_automation-tests-robotframework
```

### 3. Install Python Dependencies

Run the following command:

```bash
pip install -r requirements.txt
```
To generate/update the requirements.txt file:

```bash
pip freeze > requirements.txt
```

### 4. Web Drivers
   - [ChromeDriver](https://googlechromelabs.github.io/chrome-for-testing/)
   - [EdgeDriver](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/)

You can also use `webdrivermanager` to automatically manage drivers.

### 5. (Optional) Parallel Execution Support
```bash
pip install robotframework-pabot
```

---

## 📂 Project Structure (Example)
```
opencart_automation-tests-robotframework/
├── configs/
│   ├── config.ini
│   ├── config_end_url.ini
│   ├── config.json
│   ├── config_end_url.json
│   ├── locators.yaml
│   ├── test_data.yaml
│   └── SeleniumConfigs.robot
├── data/
│   ├── image.jpg
│   ├── image1.png
│   ├── testdata.csv
│   └── *.robot
├── page_objects/
│   ├── CommonPO.robot
│   ├── auth/
│   │   ├── RegisterTestsPO.robot
│   │   ├── LoginTestsPO.robot
│   │   ├── LogoutTestsPO.robot
│   │   └── ForgotPasswordTestsPO.robot
│   ├── ui/
│   │   ├── HeaderFooterMenuTestsPO.robot
│   │   └── CurrenciesTestsPO.robot
│   └── search/
│       └── SearchTestsPO.robot
├── test_cases/
│   ├── auth/
│   │   ├── RegisterTests.robot
│   │   ├── LoginTests.robot
│   │   ├── LogoutTests.robot
│   │   ├── ForgotPasswordTests.robot
│   ├── search/
│   │   └── SearchTests.robot
│   ├── product/
│   │   ├── ProductCompareTests.robot
│   │   ├── ProductDisplayTests.robot
│   │   ├── AddToCartTests.robot
│   │   ├── WishListTests.robot
│   │   ├── ShoppingCartTests.robot
│   │   ├── CheckoutTests.robot
│   ├── home/
│   │   └── HomePageTests.robot
│   ├── account/
│   │   ├── MyAccountTests.robot
│   │   ├── MyAccountInformationTests.robot
│   │   ├── ChangePasswordTests.robot
│   │   ├── AddressBookTests.robot
│   ├── orders/
│   │   ├── OrderHistoryTests.robot
│   │   ├── OrderInformationTests.robot
│   │   ├── ProductReturnsTests.robot
│   │   ├── DownloadsTests.robot
│   │   ├── RewardPointsTests.robot
│   │   ├── ReturnsTests.robot
│   │   ├── TransactionsTests.robot
│   │   ├── RecurringPaymentsTests.robot
│   ├── marketing/
│   │   ├── AffiliateTests.robot
│   │   ├── NewsletterTests.robot
│   ├── support/
│   │   ├── ContactUsTests.robot
│   ├── features/
│   │   ├── GiftCertificateTests.robot
│   │   ├── SpecialOffersTests.robot
│   ├── ui/
│   │   ├── HeaderFooterMenuTests.robot
│   │   ├── CurrenciesTests.robot
├── results/
├── runners/
│   ├── run_regression.bat
│   ├── run_sanity.bat
│   └── test_list.txt
├── test_results/
│   ├── log.html
│   ├── output.xml
│   ├── readxml_report_push.py
│   ├── report.html
│   └── s3_upload.py
├── utils/
│   ├── api_handler.py
│   ├── config_parser.py
│   ├── config_reader.py
│   └── custom_library.py
├── requirements.txt
├── README.md
└── .gitignore
```

---

## ✅ Naming Conventions
| Item                   | Format                           | Example                     |
|------------------------|----------------------------------|-----------------------------|
| **Headers**            | `*** Settings ***`               | `*** Test Cases ***`        |
| **Keywords**           | `PascalCase`                     | `ClickSubmitButton`         |
| **Suite Variables**    | `UPPER_SNAKE_CASE`               | `BASE_URL`                  |
| **Local Variables**    | `lower_snake_case`               | `product_name`              |
| **Resource Files**     | `lowercase_with_underscores`     | `common_keywords.robot`     |
| **Tags**               | `PascalCase`                     | `SmokeTest`, `LoginTests`   |
| **Indentation**        | `4 Spaces	`                      | `ClickSubmitButton`         |


---

## 🧪 Running Tests

### ✅ Sequential Execution

🔹 Run all test cases in a folder:

```bash
robot page_objects/
```
🔹 Run a specific test file:

```bash
robot page_objects/auth/LoginTests.robot
```
## ⚡ Parallel Execution (Using Pabot)

🔹 Run All Tests in Parallel

```bash
pabot --processes 4 --outputdir results page_objects/
```

🔹 Run Specific Tests in Parallel

```bash
pabot --processes 3 --outputdir results \
  page_objects/auth/LoginTests.robot \
  page_objects/home/HomePageTests.robot
```

🔹 Run Tests in Specific Order (with Parallel Execution)

### 1. Create a test_list.txt:

```txt
page_objects/auth/LoginTests.robot
page_objects/auth/SignupTests.robot
page_objects/home/HomePageTests.robot
```
### 2. Run with:

```bash
pabot --processes 3 --outputdir results --testlevelsplit --argumentfile test_list.txt
```

### 🔹 Run Tests by Tags

```bash
pabot --processes 3 --include SmokeTest --outputdir results page_objects/
```

---

## 🔗 Useful Links

- [Robot Framework](https://robotframework.org/)
- [User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [SeleniumLibrary](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
- [WebDriverManager](https://github.com/SergeyPirogov/webdriver_manager)
- [Pabot for Parallel Execution](https://pabot.org/)

---

## 🤝 Contributing

We welcome contributions! Feel free to:
  - Open issues
  - Suggest new features
  - Submit a pull request

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

© 2025 [VK Info Tech Private Limited.](https://github.com/VK-InfoTech)

---
## 👨‍💻 Author

Vimalkumar Murugesan – Senior QA Automation Test Engineer

📧 vimalkumarm523@gmail.com

🌐 GitHub: [VK Info Tech Private Limited.](https://github.com/VK-InfoTech)

---
## 📌 Need Help?

For any issues or support, feel free to open an issue or start a discussion. We’re happy to help 🚀

``````yaml
Let me know if you'd like this:
- In `.rst` format for Sphinx
- With GitHub Actions badge setup
- Or converted to a quick-start `README-short.md` for onboarding

Want me to generate the actual `test_list.txt` or `.gitignore` for you too?
```

