#File:     participants.py
#Purpose:  Create all participant types from the Participants ABC
#Author:   Ryan K Nash
#Date:     11 November 2025

from abc import ABC, abstractmethod

# Abstract class for all participant subclasses
class Participant(ABC):
    def __init__(self, firstname, lastname):
        self.__firstname = firstname
        self.__lastname = lastname
        
    def getFirstName(self) -> str:
        return self.__firstname
    
    def getLastName(self) -> str:
        return self.__lastname
    
    def getFullName(self):
        full_name = f"{self.__firstname} {self.__lastname}"
        return full_name
    
    def getSortName(self):
        sort_name = f"{self.__lastname}, {self.__firstname}"
        return sort_name
    
    @abstractmethod
    def __str__(self) -> str:
        """Return a string representation of the participant"""
        pass
    
# Graduate class is a participant
class Graduate(Participant):
    def __init__(self, firstname, lastname, designation, degree, major, distinction):
        super().__init__(firstname, lastname)
        self.__designation = designation
        self.__degree = degree
        self.__major = major

        # Normalize distinction so it's always a list
        if distinction is None:
            self.__distinction = []
        elif isinstance(distinction, str):
            # Single string or empty string
            self.__distinction = [distinction] if distinction.strip() else []
        else:
            # Iterable of strings
            self.__distinction = list(distinction)

    def getDistinctions(self):
        return self.__distinction
        
    def getDesignation(self):
        return self.__designation
    
    def getDegree(self):
        return self.__degree
    
    def getMajor(self):
        return self.__major
    
    def getDistinction(self):
        return self.__distinction    
    
    def hasDistinction(self) -> bool:
        return bool(self.__distinction)
    
    def __str__(self) -> str:
        base = f"{self.getFullName()}, {self.__degree} in {self.__major}"

        if not self.__distinction:
            return base

        first = self.__distinction[0]
        if len(self.__distinction) == 1:
            return f"{base}, {first}"
        else:
            return f"{base}, {first}*"
        
    def getAnnouncerCard(self) -> str:
        lines = []
        lines.append(self.getFullName())
        lines.append(f"- {self.__degree} in {self.__major}")
        for d in self.__distinction:
            lines.append(f"- {d}")
        return "\n".join(lines)
    
# Faculty class is a participant
class Faculty(Participant):
    def __init__(self, title, firstname, lastname, department):
        super().__init__(firstname, lastname)
        self.__title = title
        self.__department = department
        
    def getTitle(self):
        return self.__title
    
    def getDepartment(self):
        return self.__department
    
    def getFullName(self):
        return f"{self.__title} {super().getFullName()}"
    
    def __str__(self):
        base = f"{self.getFullName()}, {self.__department}"
        return base
    
# Guest class is a participant
class Guest(Participant):
    def __init__(self, title, firstname, lastname, affiliation):
        super().__init__(firstname, lastname)
        self.__title = title
        self.__affiliation = affiliation
        
    def getTitle(self):
        return self.__title
    
    def getAffiliation(self):
        return self.__affiliation
    
    def getFullName(self):
        return f"{self.__title} {super().getFullName()}"
    
    def __str__(self):
        base = f"{self.getFullName()}, {self.__affiliation}"
        return base