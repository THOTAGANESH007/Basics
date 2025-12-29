import random

random_number = random.randint(1,100)
# print(random_number)
cards = ['king', 'queen', 'jack', 'ace', '10', '7']
random_card = random.choice(cards)
def guess_number():
    while True:
        inp = int(input("Guess a number between 1 to 100: "))
        if inp > random_number:
            print(f"{inp} is too higher than the correct number")
        elif inp < random_number:
            print(f"{inp} is too smaller than the correct number")
        else:
            print("You guessed the correct number!!!")
            break

def guess_card():
    count = 0
    while True:
        print("Available Cars:",cards)
        inp = input("Guess a card name: ").lower()
        count += 1
        if inp not in cards:
            print ("Please Enter a correct card name:")
        elif inp != random_card:
            print("You are wrong!!!")
        else:
            if count==1:
                print("Super, You guessed in a single attempt")
                break
            else:
                print(f"Hey, You guessed in {count} attempts")
                break
            
            
def main():
    while True:
        inp = int(input("1-> Guess Number\n2-> Guess Card\n0-> Exit\nEnter Your Choice: "))
        # match inp:
        #     case 1:
        #         return guess_number()
        #     case 2:
        #         return guess_card()
        #     case 0:
        #         print("Thank You, See you later!!!")
        #         return
        #     case _:
        #         ("Please Enter a Valid Number!!!")
        if inp == 0:
            print("Thank You, See you later!!!")
            break
        if inp == 1:
            guess_number()
        elif inp == 2:
            guess_card()
        else:
            ("Please Enter a Valid Number!!!")
# Call the main function
main()