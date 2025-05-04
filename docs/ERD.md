# Entity-Relationship Diagram

The following diagram represents the database schema for the Pirago application.

```mermaid
erDiagram
    %% Core entities
    USER {
        char(28) id PK
        varchar(7) user_no
        varchar(50) email
        char(60) password
        varchar(255) avatar_url
        varchar(50) name
        char(1) gender
        json address
        char(10) birthday
        char(20) phone
        varchar(28) occupation
        varchar(28) japanese_level
        tinyint(4) status
    }
    
    ADMIN_USER {
        char(32) id PK
        char(28) merchant_id FK
        varchar(50) email
        char(60) password
        varchar(50) name
        varchar(50) title
        varchar(50) role
        tinyint(4) status
    }
    
    MERCHANT {
        char(28) id PK
        varchar(50) name
        varchar(50) merchant_no
        varchar(20) legal_registration_no
        varchar(255) address
        tinyint(4) status
    }
    
    SHOP {
        char(28) id PK
        char(28) merchant_id FK
        varchar(50) name
        varchar(20) shop_no
        varchar(28) area_id FK
        varchar(255) address
        float lat
        float lng
        tinyint(4) status
    }
    
    %% Job related entities
    JOB {
        char(28) id PK
        char(30) job_template_id
        char(28) shop_id FK
        char(28) operator_id
        char(28) category_id FK
        char(28) area_id FK
        varchar(255) title
        text description
        int(11) transportation_fee
        tinyint(4) status
    }
    
    JOB_SHIFT {
        char(31) id PK
        char(28) job_id FK
        datetime from
        datetime to
        int(4) break_time
        int(11) salary
        int(11) count
        longtext extra_wage
        tinyint(4) status
    }
    
    CONTRACT {
        char(28) id PK
        char(28) user_id FK
        char(28) shop_id FK
        char(31) job_shift_id FK
        char(28) category_id FK
        datetime from
        datetime to
        int(11) salary
        int(4) break_time
        longtext extra_wage
        tinyint(4) status
    }
    
    WORK {
        char(30) id PK
        char(28) contract_id FK
        datetime from
        datetime to
        int(4) break_time
        int(11) wages
        int(11) salary
        tinyint(4) attendance
        tinyint(4) status
    }
    
    %% Reference data
    MST_CATEGORY {
        char(28) id PK
        char(28) parent_id
        varchar(50) name
        varchar(20) code
        tinyint(4) status
    }
    
    MST_AREA {
        char(28) id PK
        char(28) parent_id
        varchar(50) name
        varchar(20) code
        float lat
        float lng
        tinyint(4) status
    }
    
    %% Financial entities
    INVOICE {
        char(27) id PK
        char(100) invoice_no
        char(29) customer_id
        char(29) contract_id
        int(11) billing_amount
        int(11) total_amount
        int(11) tax
        tinyint(4) status
    }
    
    INVOICE_ITEM {
        char(31) id PK
        char(27) invoice_id FK
        smallint(5) type
        varchar(255) name
        int(11) unit_price
        int(11) count
        int(11) amount
        tinyint(4) status
    }
    
    PAYROLL_TRANSACTION {
        char(31) id PK
        char(20) type
        varchar(34) source_id
        char(28) user_id FK
        int(11) amount
        int(11) fee
        int(11) net
        tinyint(4) status
    }
    
    USER_BANK_ACCOUNT {
        char(27) id PK
        char(28) user_id FK
        varchar(50) bank_name
        varchar(10) bank_code
        varchar(50) branch_name
        varchar(10) branch_code
        varchar(50) account_number
        varchar(50) account_name
        varchar(2) type
        tinyint(4) status
    }
    
    %% Communication entities
    CHAT {
        char(28) id PK
        char(28) ref_id
        varchar(28) user_id FK
        tinyint(4) type
        varchar(50) title
        tinyint(4) status
    }
    
    CHAT_MESSAGE {
        int(11) id PK
        char(28) chat_id FK
        char(32) sender_id
        tinyint(4) sender_type
        text content
        tinyint(4) read_status
        tinyint(4) status
    }
    
    NOTICE {
        char(28) id PK
        tinyint(4) type
        char(32) sender_id
        varchar(255) title
        text content
        datetime publish_date
        tinyint(4) status
    }
    
    %% Relationships
    USER ||--o{ USER_BANK_ACCOUNT : has
    USER ||--o{ CONTRACT : applies_for
    USER ||--o{ CHAT : participates_in
    USER ||--o{ JOB_FAVORITE : saves
    
    MERCHANT ||--o{ SHOP : owns
    MERCHANT ||--o{ ADMIN_USER : employs
    MERCHANT ||--o{ MERCHANT_BANK_ACCOUNT : has
    
    SHOP ||--o{ JOB : offers
    SHOP ||--o{ CONTRACT : fulfills
    
    JOB ||--o{ JOB_SHIFT : schedules
    JOB_SHIFT ||--o{ CONTRACT : creates
    
    CONTRACT ||--o| WORK : tracks
    CONTRACT ||--o{ PAYROLL_TRANSACTION_DETAIL : generates
    
    MST_CATEGORY ||--o{ JOB : categorizes
    MST_CATEGORY ||--o{ CONTRACT : categorizes
    
    MST_AREA ||--o{ SHOP : located_in
    MST_AREA ||--o{ JOB : located_in
    
    CHAT ||--o{ CHAT_MESSAGE : contains
    
    INVOICE ||--o{ INVOICE_ITEM : contains
    INVOICE ||--o{ INVOICE_ADJUST : modifies
    
    PAYROLL_TRANSACTION ||--o| PAYROLL_TRANSACTION_BANK_ACCOUNT : uses
    PAYROLL_TRANSACTION ||--o{ PAYROLL_TRANSACTION_DETAIL : itemizes
    
    NOTICE ||--o{ NOTICE_USER : notifies
```

## Database Flow

The Pirago application demonstrates the following main flows:

1. **User Management Flow**:
   - Users register and maintain profiles
   - Users can update their bank accounts for payment
   - Admin users manage the platform on behalf of merchants

2. **Job Posting Flow**:
   - Merchants create shops
   - Shops post jobs with specific categories and locations
   - Jobs contain shifts with time and salary details
   - Users can favorite jobs they're interested in

3. **Contract Flow**:
   - Users apply for job shifts
   - Contracts are created when applications are accepted
   - Work records track actual attendance and performance
   - Shop and user reviews are logged after completion

4. **Payment Flow**:
   - Invoices are generated for completed contracts
   - Invoice items detail the charges
   - Payroll transactions process payments to users
   - Bank account information is used for transfers

5. **Communication Flow**:
   - Chat functionality between users and shops/admin
   - Notices provide platform-wide or targeted information
   - Messages are tracked for read status

This database schema supports a comprehensive job marketplace platform where users can find temporary jobs, merchants can manage their workforce needs through shops, and the platform facilitates the entire process from job posting to payment processing. 