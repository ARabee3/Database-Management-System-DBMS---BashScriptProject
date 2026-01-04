# 🗄️ Bash Database Management System (DBMS)

[![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

A lightweight, file-based database management system built entirely in Bash. This project provides a command-line interface for creating and managing databases and tables with full CRUD operations, data validation, and CSV export capabilities.

---

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Supported Data Types](#-supported-data-types)
- [Data Validations](#-data-validations)
- [Usage Examples](#-usage-examples)
- [Security Features](#-security-features)
- [Technical Details](#-technical-details)
- [Requirements](#-requirements)
- [Limitations](#-limitations)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 💾 Database Operations
- ✅ **Create Database** - Create new databases with validation
- 📋 **List Databases** - View all available databases
- 🔌 **Connect to Database** - Switch context to work with a specific database
- 🗑️ **Delete Database** - Remove databases with confirmation prompts

### 📊 Table Operations
- ➕ **Create Table** - Define tables with custom columns and data types
- 📝 **List Tables** - Display all tables in the current database
- ❌ **Drop Table** - Delete tables with confirmation
- 📥 **Insert Row** - Add new records with data validation
- 🔍 **Select Data** - Query and display table data (all columns or specific columns)
- 🗑️ **Delete Row** - Remove records by primary key
- ✏️ **Update Cell** - Modify specific cell values
- 📤 **Export to CSV** - Export table data to CSV format

---

## 🚀 Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/bash-dbms.git
cd bash-dbms
```

2. **Make the scripts executable:**
```bash
chmod +x db.sh table.sh
```

3. **Run the main script:**
```bash
./db.sh
```

---

## 🎯 Quick Start

Here's a quick example to get you started:

```bash
# Start the DBMS
./db.sh

# Create a database
Select option: 1
Enter Database Name: test_db

# Connect to the database
Select option: 3
Enter Database Name: test_db

# Create a table
Choose option: 1
Enter table name: employees
Number of columns: 3
# Follow the prompts to create your table

# Insert some data
Choose option: 4
# Follow the prompts to insert data

# View your data
Choose option: 5
# Select all columns or specific ones
```

---

## 📁 Project Structure

```
bash-dbms/
├── db.sh             # Main database management interface
├── table.sh          # Table operations and data management
├── data/             # Directory where databases are stored (auto-created)
│   └── [dbname]/     # Individual database directories
│       ├── *.meta    # Table metadata files
│       └── *.data    # Table data files
└── README.md         # Project documentation
```

---

## 🎨 Supported Data Types

| Type | Description | Example |
|------|-------------|---------|
| 🔢 **Int** | Positive integers only | `42`, `1000` |
| 📝 **String** | Text data (max 30 chars, no `:`) | `john_doe`, `Hello World` |
| 🔣 **Float** | Decimal numbers | `3.14`, `99.99` |
| 📅 **Date** | Date in YYYY-MM-DD format | `2025-01-04` |

---

## ✅ Data Validations

The system includes comprehensive validation rules to ensure data integrity:

### 🗄️ Database Name Validation
| Rule | Description |
|------|-------------|
| ❌ **Non-empty** | Database name cannot be blank |
| 📏 **Length** | Must be between 3 and 20 characters |
| 🔤 **Format** | Must start with a letter, followed by letters, numbers, or underscores only |
| 🆔 **Uniqueness** | Database name must not already exist |
| 🛡️ **Path Safety** | Prevents path traversal attacks by sanitizing input |

### 📊 Table Name Validation
| Rule | Description |
|------|-------------|
| ❌ **Non-empty** | Table name cannot be blank |
| 🔤 **Format** | Must start with a letter, contain only alphanumeric characters and underscores |
| 🚫 **Reserved Keywords** | Cannot use SQL keywords (SELECT, FROM, WHERE, INSERT, UPDATE, DELETE, TABLE, CREATE, DROP) |
| 🆔 **Uniqueness** | Table name must not already exist in the database |

### 📋 Column Validation
| Rule | Description |
|------|-------------|
| 🔑 **Unique Names** | Column names must be unique within a table |
| 🔤 **Format Rules** | Same naming conventions as tables |
| 🚫 **Reserved Keywords** | Cannot use SQL reserved keywords |
| 👑 **Primary Key** | First column is automatically set as primary key (PK) |

### 🎯 Data Type Validation

#### 🔢 Integer Validation
- Must match pattern: `^[0-9]+$`
- Only positive integers allowed
- Example: `123`, `456789`

#### 🔣 Float Validation
- Must match pattern: `^[0-9]+([.][0-9]+)?$`
- Decimal point optional
- Example: `3.14`, `100`, `99.99`

#### 📝 String Validation
- Maximum 30 characters
- Cannot contain `:` character (used as field delimiter)
- Leading and trailing spaces are automatically trimmed
- Example: `john_doe`, `Product Name`

#### 📅 Date Validation
- Must match `YYYY-MM-DD` format
- Must be a valid calendar date (verified using system date validation)
- Example: `2025-01-04`, `1990-12-31`

### 🔑 Primary Key Validation
| Rule | Description |
|------|-------------|
| ❌ **Non-empty** | PK value cannot be blank |
| 🆔 **Uniqueness** | PK values must be unique across all rows |
| ✅ **Type Compliance** | Must match the datatype defined for the PK column |

### 🧹 Input Sanitization
- ✂️ **Whitespace Removal** - Leading and trailing spaces are automatically removed
- ❌ **Empty Check** - All inputs are validated for non-empty values
- 🚫 **Special Characters** - Field delimiter (`:`) is prohibited in string values
- 🔠 **Case Handling** - Reserved keywords are checked case-insensitively

---

## 💡 Usage Examples

### 📥 Creating a Database
```bash
Select option: 1
Enter Database Name: myapp_db
✅ Success: Database 'myapp_db' created successfully!
```

### 📊 Creating a Table
```bash
Choose option: 1
Enter table name: users
Number of columns: 3
Column 1 name: id
Datatype (Int/String/Float/Date): Int
Column 2 name: username
Datatype (Int/String/Float/Date): String
Column 3 name: created_at
Datatype (Int/String/Float/Date): Date
✅ Table 'users' created successfully!
```

### ➕ Inserting Data
```bash
Choose option: 4
Table name: users
Enter id (Int): 1
Enter username (String): john_doe
Enter created_at (Date): 2025-01-04
✅ Row inserted successfully!
```

### 🔍 Selecting Data
```bash
Choose option: 5
Enter table name: users
Available columns:
1) id
2) username
3) created_at
Select columns (* for all or e.g. 1,3): *

# Output:
id    username    created_at
1     john_doe    2025-01-04
```

### ✏️ Updating a Cell
```bash
Choose option: 7
Enter table name: users
Enter PK value: 1
Enter Column number: 2
Enter New value: jane_doe
✅ Value updated successfully.
```

### 🗑️ Deleting a Row
```bash
Choose option: 6
Enter table name: users
Enter PK value to delete: 1
✅ Row with PK '1' deleted successfully.
```

### 📤 Exporting to CSV
```bash
Choose option: 8
Enter table name to export: users
✅ Table 'users' exported to 'users.csv' successfully!
```

---

## 🔒 Security Features

- 🔐 **Permission Control** - Database directories are created with `700` permissions
- 🛡️ **Path Traversal Prevention** - Input sanitization prevents directory traversal attacks
- ⚠️ **Confirmation Prompts** - Destructive operations require explicit confirmation
- ✔️ **Script Validation** - Checks for required files before execution

---

## ⚙️ Technical Details

### 📄 File Format

**Metadata Files (.meta)**
```
column_name:datatype:PK
column_name:datatype
```

**Data Files (.data)**
```
value1:value2:value3
value1:value2:value3
```

### 🎨 Color Coding
- 🔴 **Red** - Errors and warnings
- 🟢 **Green** - Success messages
- 🟡 **Yellow** - Warnings and prompts
- 🔵 **Blue** - Headers and informational text

---

## 📦 Requirements

- Bash 4.0 or higher
- Standard Unix utilities: `awk`, `sed`, `grep`, `cut`, `paste`, `column`, `date`
- Linux or Unix-like operating system

---

## ⚠️ Limitations

- ⚙️ Single-user system (no concurrent access handling)
- 🔄 No transaction support
- 🔍 No indexing (linear search for all operations)
- 💾 Limited to local file system storage

---

## 🚀 Future Enhancements

- [ ] Multi-table JOIN operations
- [ ] WHERE clause filtering in SELECT
- [ ] Backup and restore functionality
- [ ] User authentication and permissions
- [ ] Transaction support with rollback
- [ ] Indexing for faster lookups
- [ ] Support for NULL values
- [ ] Import data from CSV
- [ ] Foreign key constraints
- [ ] Aggregate functions (COUNT, SUM, AVG)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. 🍴 Fork the repository
2. 🔧 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. ✅ Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🎉 Open a Pull Request

---

## 📝 License

This project is open source and available under the MIT License.

---

## 👨‍💻 Author

Created as an educational project to demonstrate database management concepts using Bash scripting, for ITI Open Source 9-Months Program.

Developed By: Ahmed Rabie & Mokhtar Mohamed

---

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

---

## 📸 Screenshots

### Main Menu
```
==========================================
       BASH DATABASE MANAGEMENT SYSTEM
==========================================
1) Create Database
2) List Databases
3) Connect to Database
4) Delete Database
5) Exit
```

### Table Operations Menu
```
1) Create Table
2) List Tables
3) Drop Table
4) Insert Row
5) Select Data
6) Delete Row
7) Update Cell
8) Export To CSV (Bonus)
9) Exit
```

---

<div align="center">

**Made with ❤️ and Bash**

[Report Bug](https://github.com/ARabee3/bash-dbms/issues) • [Request Feature](https://github.com/ARabee3/bash-dbms/issues)

</div>
