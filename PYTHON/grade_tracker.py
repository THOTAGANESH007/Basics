students_data = {}
subjects = ['Maths', 'Physics', 'Chemistry', 'Biology', 'English', 'Social']

# Grade Calculation
def find_subject_grade(marks):
    if 90 <= marks <= 100:
        return 'A'
    elif 80 <= marks < 90:
        return 'B'
    elif 70 <= marks < 80:
        return 'C'
    elif 60 <= marks < 70:
        return 'D'
    elif 50 <= marks < 60:
        return 'E'
    else:
        return 'F'


def overall_grade(avg):
    return find_subject_grade(avg)

# Search Student
def search_student():
    roll_number = int(input("Enter Roll Number: "))
    student_name = input("Enter Student Name: ")
    key = f"{roll_number}_{student_name}"
    return key, students_data.get(key)

# Add / Update / Delete Student
def add_or_update_student():
    key, student = search_student()

    if student:
        print("\nStudent Found!")
        choice = int(input("1 -> Update Marks\n2 -> Delete Student\nChoose: "))

        if choice == 1:
            for sub in subjects:
                student[sub] = int(input(f"Enter updated marks for {sub}: "))
            print("Marks updated successfully!")

        elif choice == 2:
            students_data.pop(key)
            print("Student deleted successfully!")

        else:
            print("Invalid choice!")

    else:
        marks = {}
        for sub in subjects:
            marks[sub] = int(input(f"Enter marks for {sub}: "))
        students_data[key] = marks
        print("Student added successfully!")

def student_analytics(student):
    # 1. Initialize variables
    total = 0

    max_marks = -1
    min_marks = 101

    max_subject = ""
    min_subject = ""

    # 2. Loop through each subject
    for subject in student:
        marks = student[subject]

        # Add marks for total
        total += marks

        # Check maximum
        if marks > max_marks:
            max_marks = marks
            max_subject = subject

        # Check minimum
        if marks < min_marks:
            min_marks = marks
            min_subject = subject

    # 3. Calculate average
    avg = total / len(student)

    # 4. Print analytics
    print("\n--- Student Analytics ---")
    print(f"Total Marks   : {total}")
    print(f"Average Marks : {avg:.2f}")
    print(f"Max Marks     : {max_marks} in {max_subject}")
    print(f"Min Marks     : {min_marks} in {min_subject}")
    print(f"Overall Grade : {find_subject_grade(avg)}")

    # 5. Subject-wise grades
    print("\nSubject-wise Grades:")
    for subject in student:
        marks = student[subject]
        grade = find_subject_grade(marks)
        print(f"{subject:<10}: {marks} -> {grade}")



def class_analytics():

    # 1. Check if data exists
    if len(students_data) == 0:
        print("No students data available!")
        return

    # 2. Initialize variables
    total_marks_all = 0
    total_subjects_all = 0

    topper_name = ""
    topper_marks = -1

    lowest_name = ""
    lowest_marks = 1000

    grade_count = {'A':0, 'B':0, 'C':0, 'D':0, 'E':0, 'F':0}

    subject_max = {}
    subject_min = {}

    # Initialize subject max & min
    for sub in subjects:
        subject_max[sub] = -1
        subject_min[sub] = 101

    # 3. Loop through each student
    for student_key in students_data:
        student = students_data[student_key]

        student_total = 0

        # 4. Loop through each subject of a student
        for subject in student:
            marks = student[subject]

            student_total += marks
            total_marks_all += marks
            total_subjects_all += 1

            # Update subject-wise max
            if marks > subject_max[subject]:
                subject_max[subject] = marks

            # Update subject-wise min
            if marks < subject_min[subject]:
                subject_min[subject] = marks

            # Count grade
            grade = find_subject_grade(marks)
            grade_count[grade] += 1

        # 5. Check topper
        if student_total > topper_marks:
            topper_marks = student_total
            topper_name = student_key

        # 6. Check lowest scorer
        if student_total < lowest_marks:
            lowest_marks = student_total
            lowest_name = student_key

    # 7. Calculate class average
    class_avg = total_marks_all / total_subjects_all

    # 8. Print results
    print("\n=== Class Analytics ===")
    print(f"Class Average Marks : {class_avg:.2f}")
    print(f"Topper              : {topper_name} ({topper_marks})")
    print(f"Lowest Scorer       : {lowest_name} ({lowest_marks})")

    print("\nSubject-wise Max & Min:")
    for sub in subjects:
        print(f"{sub:<10}: Max={subject_max[sub]}, Min={subject_min[sub]}")

    print("\nGrade Distribution:")
    for grade in grade_count:
        print(f"Grade {grade}: {grade_count[grade]}")



# Main Menu
def main():
    while True:
        choice = int(input("""
==============================
1 -> Search Student
2 -> Add / Update / Delete Student
3 -> Student Analytics
4 -> Class Analytics
0 -> Exit
Enter choice: """))

        if choice == 0:
            print("Thank you for using the system!")
            break

        elif choice == 1:
            key, student = search_student()
            print("Student Found!" if student else "Student Not Found!")

        elif choice == 2:
            add_or_update_student()

        elif choice == 3:
            key, student = search_student()
            if student:
                student_analytics(student)
            else:
                print("Student not found!")

        elif choice == 4:
            class_analytics()

        else:
            print("Invalid choice!")

# Run Program
main()
