#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define BUFSIZE 256
#define TABLESIZE 50021
#define getline getLine

typedef struct Node
{
    char *word;
    struct Node *next;
} Node;

ssize_t getLine(char **lineptr, size_t *n, FILE *stream)
{
    int c;
    size_t len = 0;

    if(lineptr == NULL || n == NULL || stream == NULL)
        return -1;

    if(*lineptr == NULL || *n == 0)
    {
        *n = BUFSIZE;
        *lineptr = malloc(*n);
        if(*lineptr == NULL)
            return -1;
    }

    while((c = fgetc(stream)) != EOF)
    {
        if(len + 1 >= *n)
        {
            size_t newSize = *n * 2;
            char *newLine = realloc(*lineptr, newSize);
            if(newLine == NULL)
                return -1;
            *lineptr = newLine;
            *n = newSize;
        }

        (*lineptr)[len++] = c;
        if(c == '\n')
            break;
    }

    if(len == 0 && c == EOF)
        return -1;

    (*lineptr)[len] = '\0';
    return len;
}

char *copyString(char *str)
{
    char *copy = malloc(strlen(str) + 1);
    if(copy == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    strcpy(copy, str);
    return copy;
}

unsigned int hash(char *str)
{
    unsigned long hashValue = 5381;
    int c;

    while((c = *str++) != '\0')
        hashValue = ((hashValue << 5) + hashValue) + c;

    return hashValue % TABLESIZE;
}

Node **initializeHash()
{
    Node **hashTable = calloc(TABLESIZE, sizeof(Node *));
    if(hashTable == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    return hashTable;
}

int checkIfExists(Node **hashTable, char *word)
{
    unsigned int index = hash(word);
    Node *current = hashTable[index];

    while(current != NULL)
    {
        if(strcmp(current->word, word) == 0)
            return 1;
        current = current->next;
    }

    return 0;
}

void addToHash(Node **hashTable, char *word)
{
    if(checkIfExists(hashTable, word))
        return;

    unsigned int index = hash(word);
    Node *newNode = malloc(sizeof(Node));
    if(newNode == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    newNode->word = copyString(word);
    newNode->next = hashTable[index];
    hashTable[index] = newNode;
}

int suggestionAlreadyPrinted(char **suggestions, int suggestionCount, char *word)
{
    for(int i = 0; i < suggestionCount; i++)
    {
        if(strcmp(suggestions[i], word) == 0)
            return 1;
    }

    return 0;
}

void printSuggestion(Node **hashTable, char *candidate, char **suggestions, int *suggestionCount, int *firstSuggestion)
{
    if(checkIfExists(hashTable, candidate) && !suggestionAlreadyPrinted(suggestions, *suggestionCount, candidate))
    {
        if(!(*firstSuggestion))
            printf(", ");
        printf("%s", candidate);
        *firstSuggestion = 0;
        suggestions[*suggestionCount] = copyString(candidate);
        (*suggestionCount)++;
    }
}

void checkMissingLetters(Node **hashTable, char *word, char **suggestions, int *suggestionCount, int *firstSuggestion)
{
    int len = strlen(word);
    char *candidate = malloc(len + 2);

    if(candidate == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    for(int i = 0; i <= len; i++)
    {
        for(char letter = 'a'; letter <= 'z'; letter++)
        {
            memcpy(candidate, word, i);
            candidate[i] = letter;
            strcpy(candidate + i + 1, word + i);
            printSuggestion(hashTable, candidate, suggestions, suggestionCount, firstSuggestion);
        }
    }

    free(candidate);
}

void checkExtraLetters(Node **hashTable, char *word, char **suggestions, int *suggestionCount, int *firstSuggestion)
{
    int len = strlen(word);
    char *candidate = malloc(len + 1);

    if(candidate == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    for(int i = 0; i < len; i++)
    {
        memcpy(candidate, word, i);
        strcpy(candidate + i, word + i + 1);
        printSuggestion(hashTable, candidate, suggestions, suggestionCount, firstSuggestion);
    }

    free(candidate);
}

void checkInvertedLetters(Node **hashTable, char *word, char **suggestions, int *suggestionCount, int *firstSuggestion)
{
    int len = strlen(word);
    char *candidate = malloc(len + 1);

    if(candidate == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    for(int i = 0; i < len - 1; i++)
    {
        strcpy(candidate, word);
        char temp = candidate[i];
        candidate[i] = candidate[i + 1];
        candidate[i + 1] = temp;
        printSuggestion(hashTable, candidate, suggestions, suggestionCount, firstSuggestion);
    }

    free(candidate);
}

void printSuggestions(Node **hashTable, char *word)
{
    int len = strlen(word);
    char **suggestions = malloc(sizeof(char *) * (54 * len + 26));
    int suggestionCount = 0;
    int firstSuggestion = 1;

    if(suggestions == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    printf("Suggestions: "); //the suggested words should follow
    checkMissingLetters(hashTable, word, suggestions, &suggestionCount, &firstSuggestion);
    checkExtraLetters(hashTable, word, suggestions, &suggestionCount, &firstSuggestion);
    checkInvertedLetters(hashTable, word, suggestions, &suggestionCount, &firstSuggestion);
    printf("\n");

    for(int i = 0; i < suggestionCount; i++)
        free(suggestions[i]);
    free(suggestions);
}

void freeHash(Node **hashTable)
{
    for(int i = 0; i < TABLESIZE; i++)
    {
        Node *current = hashTable[i];
        while(current != NULL)
        {
            Node *next = current->next;
            free(current->word);
            free(current);
            current = next;
        }
    }
    free(hashTable);
}

int main(int argc, char **argv)
{
    if(argc < 4)
    {
        fprintf(stderr, "Usage: %s <dictionary> <input> <add|ignore>\n", argv[0]);
        return 1;
    }

	char *dictionaryFilePath = argv[1]; //this keeps the path to the dictionary file file
	char *inputFilePath = argv[2]; //this keeps the path to the input text file
	char *check = argv[3]; // this keeps the flag to whether we should insert mistyped words into dictionary or ignore
	int numOfWords=0; //this variable will tell us how much memory to allocate

	int insertToDictionary;
	if(strcmp(check,"add")==0)
		insertToDictionary = 1;
	else
		insertToDictionary = 0;
    
	////////////////////////////////////////////////////////////////////
	//read dictionary file
    FILE *fp = fopen(dictionaryFilePath, "r");
    char *line = NULL; //variable to be used for line counting
    size_t lineBuffSize = 0; //variable to be used for line counting
    ssize_t lineSize; //variable to be used for line counting

    //check if the file is accessible, just to make sure...
    if(fp == NULL)
    {
        fprintf(stderr, "Error opening file\n");
        exit(1);
    }

    //First, let's count number of words in the dictionary.
    //This will help us know how much memory to allocate for our hash table
    while((lineSize = getline(&line,&lineBuffSize,fp)) !=-1)
        numOfWords++;
    free(line); //getline internally allocates memory, so we need to free it here so as not to leak memory!!

    //Printing line count for debugging purposes.
    //You can remove this part from your submission.
    //printf("%d\n",numOfWords);
    
    //HINT: You can initialize your hash table here, since you know the size of the dictionary
    Node **hashTable = initializeHash();
    
    //rewind file pointer to the beginning of the file, to be able to read it line by line.
    fseek(fp, 0, SEEK_SET);

    char wrd[BUFSIZE];
    for (int i = 0; i < numOfWords; i++)
    {
        fscanf(fp, "%255s \n", wrd);
        //You can print the words for Debug purposes, just to make sure you are loading the dictionary as intended
        //printf("%d: %s\n",i,wrd);
        
        //HINT: here is a good place to insert the words into your hash table
        addToHash(hashTable, wrd);
    }
    fclose(fp);
    line = NULL;
    lineBuffSize = 0;
    
	////////////////////////////////////////////////////////////////////
	//read the input text file word by word
    fp = fopen(inputFilePath, "r");
	
	//check if the file is accessible, just to make sure...
	if(fp == NULL)
	{
		fprintf(stderr, "Error opening file\n");
		return -1;
	}

    //HINT: You can use a flag to indicate if there is a misspleed word or not, which is initially set to 1
	int noTypo=1;

	//read a line from the input file
	while((lineSize = getline(&line,&lineBuffSize,fp)) !=-1)
	{
		char *word;
        //These are the delimiters you are expected to check for. Nothing else is needed here.
		const char delimiter[]= " ,.:;!\n";

		//split the buffer by delimiters to read a single word
		word = strtok(line,delimiter); 
		
		//read the line word by word
		while(word!=NULL)
		{
            // You can print the words of the inpit file for Debug purposes, just to make sure you are loading the input text as intended
			//printf("%s\n",word);

            
            // HINT: Since this nested while loop will keep reading the input text word by word, here is a good place to check for misspelled words
            if(!checkIfExists(hashTable, word))
            {
                noTypo = 0;
            
            
            // INPUT/OUTPUT SPECS: use the following line for printing a "word" that is misspelled.
                printf("Misspelled word: %s\n",word);
            
            // INPUT/OUTPUT SPECS: use the following line for printing suggestions, each of which will be separated by a comma and whitespace.
                //printf("Suggestions: "); //the suggested words should follow
                printSuggestions(hashTable, word);
                if(insertToDictionary)
                    addToHash(hashTable, word);
            }
            
            
            
			word = strtok(NULL,delimiter); 
		}
	}
    free(line); //getline internally allocates memory, so we need to free it here so as not to leak memory!!
	fclose(fp);
    
    //HINT: If the flag noTypo is not altered (which you should do in the loop above if there exists a word not in the dictionary), then you should print "No typo!"
    if(noTypo==1)
        printf("No typo!\n");
    

    // DON'T FORGET to free the memory that you allocated
    freeHash(hashTable);
    
	return 0;
}
