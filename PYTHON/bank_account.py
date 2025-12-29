class Account:
    def __init__(self, account_number, holder_name, balance=0):
        self.account_number = account_number
        self.holder_name = holder_name
        self.balance = balance

    def deposit(self, amount):
        if amount <= 0:
            print("Deposit amount must be positive")
            return
        self.balance += amount
        print(f"Deposited ₹{amount}")

    def withdraw(self, amount):
        if amount <= 0:
            print("Withdrawal amount must be positive")
            return
        if amount > self.balance:
            print("Insufficient balance")
            return
        self.balance -= amount
        print(f"Withdrawn ₹{amount}")

    def check_balance(self):
        print(f"Current Balance: ₹{self.balance}")


class SavingsAccount(Account):
    def __init__(self, account_number, holder_name, balance=0, interest_rate=0.03):
        super().__init__(account_number, holder_name, balance)
        self.interest_rate = interest_rate

    def add_interest(self):
        interest = self.balance * self.interest_rate
        self.balance += interest
        print(f"Interest added: ₹{interest:.2f}")


# Create a savings account
acc = SavingsAccount("SA101", "Ganesh Thota", 5000)

acc.check_balance()
acc.deposit(2000)
acc.withdraw(1500)
acc.add_interest()
acc.check_balance()
