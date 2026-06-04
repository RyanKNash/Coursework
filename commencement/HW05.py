#File:     HW05.py
#Purpose:  Contains main to test implementation of participants and the graduation ceremony 
#Author:   Ryan K Nash
#Date:     15 November 2025

from participants import Graduate, Faculty, Guest
from graduation import GraduationCeremony
import random

# --- Data to for testing ---
FIRST = [
    "Tifa", "Aerith", "Cloud", "Zidane", "Vivi", "Yuna", "Auron", "Luke", "Anakin",
    "Rey",  "Donkey", "Diddy", "Crash", "Spyro", "Coco", "Samus"
    ]
LAST = ["Skywalker", "Kenobi",  "Strife", "Leonhart", "Highwind", "Kong"]
DESIG = ["UG", "G"]
DEGREES = ["B.S.", "B.A.", "M.S."]
MAJORS = ["Computer Science", "Information Systems", "Cybersecurity", "Software Engineering", "Data Science"]
DISTINCTIONS = ["Summa Cum Laude", "Magna Cum Laude", "Cum Laude", "With Honors", ""]  # empty = none for testing
TITLES = ["Dr.", "Prof."]
AFFILIATIONS =[
               "Umbrella Corp", "Shinra Electric Power Company",
               "Abstergo Industries", "Vault-Tec Research Division", "Evil Corp"
            ]

# --- Test graduate ---
def random_graduate() -> Graduate:
    return Graduate(
        firstname=random.choice(FIRST),
        lastname=random.choice(LAST),
        designation=random.choice(DESIG),
        degree=random.choice(DEGREES),
        major=random.choice(MAJORS),
        distinction=random.choice(DISTINCTIONS)
)
    
def random_faculty() -> Faculty:
    return Faculty(
        firstname=random.choice(FIRST),
        lastname=random.choice(LAST),
        title=random.choice(TITLES),
        department=random.choice(MAJORS) # same idea
)
    
def random_guest() -> Guest:
    return Guest(
        firstname=random.choice(FIRST),
        lastname=random.choice(LAST),
        title=random.choice(TITLES),
        affiliation=random.choice(AFFILIATIONS)
)
    
def main():
    ceremony = GraduationCeremony("Drexel University", "June 15, 2025")

    # ---- Add some speakers, grads and guests ----
    # One hard coded faculty member
    f1 = Faculty("Dr.", "Jeremy", "Johnson", "Computer Science")
    faculty = [f1]
    for _ in range(2, 20):
        faculty.append(random_faculty())

    # One hard coded guest
    gu1 = Guest("Dr.", "Bruce", "Banner", "Avengers Initiative")
    guests = [gu1]
    for _ in range(2, 5):
        guests.append(random_guest())

    # Add a couple extra speakers for testing priority order
    f2 = faculty[1]
    gu2 = guests[1]

    # Add speakers and test PriorityQueue behavior
    ceremony.addSpeaker(f1, priority=1)
    ceremony.addSpeaker(gu1, priority=2)
    ceremony.addSpeaker(f2, priority=4)  # out of order for testing
    ceremony.addSpeaker(gu2, priority=3)

    # One hard coded student in each G and UG category
    gr1 = Graduate("Ada", "Lovelace", "G", "M.S.", "Computer Science",
                   ["Cum Laude", "Best Thesis", "With Honors"])
    gr2 = Graduate("Alan", "Turing", "UG", "B.S.", "Mathematics", "")
    graduates = [gr1, gr2]

    # Add a bunch of random grads
    for _ in range(3, 40):
        graduates.append(random_graduate())

    # Load all graduates into the ceremony queues
    for grad in graduates:
        ceremony.addGraduate(grad)

    # Add stage party members
    for f in faculty:
        ceremony.addStagePartyMember(f)
    for g in guests:
        ceremony.addStagePartyMember(g)

    # --- Print program text before simulating the ceremony ---
    print("=== PROGRAM TEXT ===")
    print(ceremony.getProgramText())
    print()

    # --- Print an announcer card example ---
    print("=== Announcer card for first grad ===")
    # Only printing one card for testing reasons,
    # printing them all was too mush terminal noise
    print(gr1.getAnnouncerCard())
    print()

    # --- Simulate the ceremony: speakers & graduates walk ---
    while ceremony.hasNextSpeaker():
        ceremony.getNextSpeaker()

    while ceremony.hasNextGraduate():
        ceremony.getNextGraduate()

    # --- Print recessional order (LIFO stage party) ---
    print("=== Recessional order ===")
    print(ceremony.getRecessional())
    print()

    # --- Print Photo Manifest ---
    photo_head = ceremony.getPhotoManifest()
    current = photo_head

    print("=== Photo Manifest ===")
    if current is None:
        print("  <empty>")
    else:
        while current is not None:
            participant = current.getData()
            print(f"- {participant.getFullName()}")
            current = current.getNext()


if __name__ == "__main__":
    main()