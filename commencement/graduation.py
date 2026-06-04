#File:     graduation.py
#Purpose:  Create a graduation object that will hold all information in a graduation ceremony
#Author:   Ryan K Nash
#Date:     11 November 2025

from queue import Queue, LifoQueue, PriorityQueue
from participants import Graduate, Faculty, Guest
from linkedlist import LinkedList, Node

class GraduationCeremony():
    """
    Represents a graduation ceremony.

    Manages:
    - speakers (priority queue)
    - graduates & undergraduates (FIFO queues)
    - stage party (stack)
    - photo manifest (linked list)
    """
    def __init__(self, university, date):
        self.__university = university
        self.__date = date

        # Data structures for participants
        self.__speakers = PriorityQueue()
        self.__graduates = Queue()
        self.__undergraduates = Queue()
        self.__stageParty = LifoQueue()
        self.__photoManifest = LinkedList()

        # Used to preserve insertion order when priorities are equal
        self.__speaker_order_counter = 0
        
    # Accessors
    def getUniversity(self) -> str:
        return self.__university

    def getDate(self) -> str:
        return self.__date
        
    def addGraduate(self, graduate: Graduate) -> None:
        """
        Add a Graduate to the appropriate queue based on their designation.
        "G"  - graduate queue
        "UG" - undergraduate queue
        """
        designation = graduate.getDesignation()
        if designation == "G":
            self.__graduates.put(graduate)
        elif designation == "UG":
            self.__undergraduates.put(graduate)
        else:
            raise ValueError(f"Unknown designation for graduate: {designation}")
    
    def addSpeaker(self, speaker, priority) -> None:
        """
        Add a speaker with a given priority.
        Lower priority number means earlier speaking order.
        """
        entry = (priority, self.__speaker_order_counter, speaker)
        self.__speakers.put(entry)
        self.__speaker_order_counter += 1
    
    def addStagePartyMember(self, participant) -> None:
        """
        Push a participant onto the stage party stack.
        """
        self.__stageParty.put(participant)
    
    def getProgramText(self) -> str:
            """
            Build and return the full program text as a single multiline string
            without mutating any of the ceremony queues/stacks.

            Format:
            <university> Commencement Ceremony
            <date>

            Speakers:
            - each speaker (by priority order)

            Graduate Students:
            - each grad (designation 'G'), sorted by sort name

            Undergraduate Students:
            - each grad (designation 'UG'), sorted by sort name
            """
            lines = []

            # Header
            lines.append(f"{self.__university} Commencement Ceremony")
            lines.append(self.__date)
            lines.append("")

            # ----------- Speakers -----------
            lines.append("Speakers:")

            speakers_list = list(self.__speakers.queue)
            
            def sort_key(entry):
                return entry[0], entry[1]

            speakers_list.sort(key=sort_key)

            for priority, order, participant in speakers_list:
                lines.append(f"- {participant}")
            lines.append("")

            # -------- Graduates / Undergraduates --------
            grad_list = list(self.__graduates.queue)
            ug_list = list(self.__undergraduates.queue)

            grad_students = [g for g in grad_list if g.getDesignation() == "G"]
            ug_students = [g for g in ug_list if g.getDesignation() == "UG"]
            
            def sort_by_name(student):
                return student.getSortName()

            grad_students.sort(key=sort_by_name)
            ug_students.sort(key=sort_by_name)

            # Graduate Students section
            lines.append("Graduate Students:")
            for g in grad_students:
                lines.append(f"- {g}")
            lines.append("")

            # Undergraduate Students section
            lines.append("Undergraduate Students:")
            for g in ug_students:
                lines.append(f"- {g}")

            return "\n".join(lines)
    
    def hasNextSpeaker(self) -> bool:
        """
        Return True if there is another speaker in the queue.
        """
        return not self.__speakers.empty()
    
    def getNextSpeaker(self):
        """
        Return the next speaker by priority, add them to the photo manifest,
        and remove them from the speaker queue.
        Returns None if no speakers remain.
        """
        if self.__speakers.empty():
            return None

        priority, order, participant = self.__speakers.get()
        self.__photoManifest.append(participant)

        return participant
    
    def hasNextGraduate(self) -> bool:
        """
        True if there is at least one graduate or undergraduate left to walk.
        """
        return (not self.__graduates.empty()) or (not self.__undergraduates.empty())
    
    def getNextGraduate(self):
        """
        Return the next Graduate to walk.
        Graduate students (designation "G") go first; once they are exhausted,
        undergraduates (designation "UG") go.
        The graduate is also appended to the photo manifest.
        Returns None if none remain.
        """
        grad = None

        if not self.__graduates.empty():
            grad = self.__graduates.get()
        elif not self.__undergraduates.empty():
            grad = self.__undergraduates.get()

        if grad is not None:
            self.__photoManifest.append(grad)

        return grad
    
    def getRecessional(self):
        """
        The stage party leaves the stage in reverse order of arrival (LIFO).
        Returns a list of full names in the order they recess.
        """
        names = []
        while not self.__stageParty.empty():
            person = self.__stageParty.get()
            names.append(person.getFullName())
        return names
    
    def getPhotoManifest(self):
        """
        Returns the head node of the photo manifest linked list.
        """
        return self.__photoManifest.getHead()