#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <limits.h>

struct GradeEntry {
    char studentId[11];
    char assignmentName[21];
    unsigned short grade;
};

typedef struct Node {
    struct GradeEntry entry;
    struct Node *next;
} Node;

static void free_list(Node *head) {
    while (head != NULL) {
        Node *next = head->next;
        free(head);
        head = next;
    }
}

static void fatal(Node *head, const char *message) {
    fprintf(stderr, "%s\n", message);
    free_list(head);
    exit(1);
}

static int is_valid_student_id(const char *s) {
    if (s == NULL || strlen(s) != 10) {
        return 0;
    }
    for (int i = 0; i < 10; i++) {
        if (!isdigit((unsigned char)s[i])) {
            return 0;
        }
    }
    return 1;
}

static int is_valid_assignment_name(const char *s) {
    if (s == NULL) {
        return 0;
    }
    size_t len = strlen(s);
    if (len < 1 || len > 20) {
        return 0;
    }
    for (size_t i = 0; i < len; i++) {
        if (s[i] == ':') {
            return 0;
        }
    }
    return 1;
}

static int parse_grade_str(const char *s, unsigned short *outGrade) {
    if (s == NULL || *s == '\0') {
        return 0;
    }

    char *endptr = NULL;
    long value = strtol(s, &endptr, 10);

    if (*endptr != '\0') {
        return 0;
    }
    if (value < 0 || value > 100) {
        return 0;
    }

    *outGrade = (unsigned short)value;
    return 1;
}

static int parse_db_line(const char *line, struct GradeEntry *out) {
    if (line == NULL || out == NULL) {
        return 0;
    }

    const char *first = strchr(line, ':');
    if (first == NULL) {
        return 0;
    }

    const char *second = strchr(first + 1, ':');
    if (second == NULL) {
        return 0;
    }

    if (strchr(second + 1, ':') != NULL) {
        return 0;
    }

    size_t studentLen = (size_t)(first - line);
    size_t assignmentLen = (size_t)(second - (first + 1));
    const char *gradeStr = second + 1;

    if (studentLen != 10 || assignmentLen < 1 || assignmentLen > 20) {
        return 0;
    }

    char studentId[11];
    char assignmentName[21];
    memcpy(studentId, line, studentLen);
    studentId[studentLen] = '\0';
    memcpy(assignmentName, first + 1, assignmentLen);
    assignmentName[assignmentLen] = '\0';

    unsigned short grade;
    if (!is_valid_student_id(studentId) ||
        !is_valid_assignment_name(assignmentName) ||
        !parse_grade_str(gradeStr, &grade)) {
        return 0;
    }

    strcpy(out->studentId, studentId);
    strcpy(out->assignmentName, assignmentName);
    out->grade = grade;

    return 1;
}

static int parse_add_argument(const char *arg, struct GradeEntry *out) {
    return parse_db_line(arg, out);
}

static int parse_remove_argument(const char *arg, char *studentId, char *assignmentName) {
    if (arg == NULL || studentId == NULL || assignmentName == NULL) {
        return 0;
    }

    const char *first = strchr(arg, ':');
    if (first == NULL) {
        return 0;
    }
    if (strchr(first + 1, ':') != NULL) {
        return 0;
    }

    size_t studentLen = (size_t)(first - arg);
    size_t assignmentLen = strlen(first + 1);

    if (studentLen != 10 || assignmentLen < 1 || assignmentLen > 20) {
        return 0;
    }

    memcpy(studentId, arg, studentLen);
    studentId[studentLen] = '\0';
    memcpy(assignmentName, first + 1, assignmentLen);
    assignmentName[assignmentLen] = '\0';

    if (!is_valid_student_id(studentId) || !is_valid_assignment_name(assignmentName)) {
        return 0;
    }

    return 1;
}

static int entry_exists(Node *head, const char *studentId, const char *assignmentName) {
    for (Node *curr = head; curr != NULL; curr = curr->next) {
        if (strcmp(curr->entry.studentId, studentId) == 0 &&
            strcmp(curr->entry.assignmentName, assignmentName) == 0) {
            return 1;
        }
    }
    return 0;
}

static int append_entry(Node **head, Node **tail, const struct GradeEntry *entry) {
    Node *node = malloc(sizeof(Node));
    if (node == NULL) {
        return 0;
    }

    node->entry = *entry;
    node->next = NULL;

    if (*head == NULL) {
        *head = node;
        *tail = node;
    } else {
        (*tail)->next = node;
        *tail = node;
    }

    return 1;
}

static int remove_entry(Node **head, Node **tail, const char *studentId, const char *assignmentName) {
    Node *prev = NULL;
    Node *curr = *head;

    while (curr != NULL) {
        if (strcmp(curr->entry.studentId, studentId) == 0 &&
            strcmp(curr->entry.assignmentName, assignmentName) == 0) {
            if (prev == NULL) {
                *head = curr->next;
            } else {
                prev->next = curr->next;
            }

            if (curr == *tail) {
                *tail = prev;
            }

            free(curr);
            return 1;
        }

        prev = curr;
        curr = curr->next;
    }

    return 0;
}

static void print_entries(Node *head) {
    printf("Student ID | Assignment Name      | Grade\n");
    printf("-----------------------------------------\n");

    for (Node *curr = head; curr != NULL; curr = curr->next) {
        printf("%-10s | %-20s | %hu\n",
               curr->entry.studentId,
               curr->entry.assignmentName,
               curr->entry.grade);
    }
}

static int print_stats(Node *head, const char *assignmentName) {
    int found = 0;
    unsigned short min = 0;
    unsigned short max = 0;
    unsigned int sum = 0;
    unsigned int count = 0;

    for (Node *curr = head; curr != NULL; curr = curr->next) {
        if (strcmp(curr->entry.assignmentName, assignmentName) == 0) {
            if (!found) {
                min = curr->entry.grade;
                max = curr->entry.grade;
                found = 1;
            } else {
                if (curr->entry.grade < min) min = curr->entry.grade;
                if (curr->entry.grade > max) max = curr->entry.grade;
            }
            sum += curr->entry.grade;
            count++;
        }
    }

    if (!found) {
        return 0;
    }

    double mean = (double)sum / (double)count;

    printf("Grade statistics for %s\n", assignmentName);
    printf("Min: %hu\n", min);
    printf("Max: %hu\n", max);
    printf("Mean: %.2f\n", mean);

    return 1;
}

static Node *load_database(FILE *fp, Node **tailOut) {
    Node *head = NULL;
    Node *tail = NULL;

    char *line = NULL;
    size_t cap = 0;
    ssize_t nread;

    while ((nread = getline(&line, &cap, fp)) != -1) {
        if (nread > 0 && line[nread - 1] == '\n') {
            line[nread - 1] = '\0';
        }

        struct GradeEntry entry;
        if (!parse_db_line(line, &entry)) {
            free(line);
            free_list(head);
            return NULL;
        }

        if (entry_exists(head, entry.studentId, entry.assignmentName)) {
            free(line);
            free_list(head);
            return NULL;
        }

        if (!append_entry(&head, &tail, &entry)) {
            free(line);
            free_list(head);
            return NULL;
        }
    }

    free(line);
    *tailOut = tail;
    return head;
}

static int save_database(const char *dbPath, Node *head) {
    char tempTemplate[] = "./grades_tmp_XXXXXX";
    int tempFd = mkstemp(tempTemplate);
    if (tempFd == -1) {
        return 0;
    }

    FILE *tempFp = fdopen(tempFd, "w");
    if (tempFp == NULL) {
        close(tempFd);
        unlink(tempTemplate);
        return 0;
    }

    for (Node *curr = head; curr != NULL; curr = curr->next) {
        if (fprintf(tempFp, "%s:%s:%hu\n",
                    curr->entry.studentId,
                    curr->entry.assignmentName,
                    curr->entry.grade) < 0) {
            fclose(tempFp);
            unlink(tempTemplate);
            return 0;
        }
    }

    if (fclose(tempFp) != 0) {
        unlink(tempTemplate);
        return 0;
    }

    if (rename(tempTemplate, dbPath) != 0) {
        unlink(tempTemplate);
        return 0;
    }

    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Invalid arguments\n");
        return 1;
    }

    const char *dbPath = argv[1];

    if (access(dbPath, F_OK) != 0) {
        fprintf(stderr, "Database file does not exist\n");
        return 1;
    }
    if (access(dbPath, R_OK) != 0) {
        fprintf(stderr, "Database file is not readable\n");
        return 1;
    }
    if (access(dbPath, W_OK) != 0) {
        fprintf(stderr, "Database file is not writable\n");
        return 1;
    }

    FILE *fp = fopen(dbPath, "r");
    if (fp == NULL) {
        fprintf(stderr, "Could not open database file\n");
        return 1;
    }

    Node *tail = NULL;
Node *head = load_database(fp, &tail);

if (head == NULL) {
    fclose(fp);
    fprintf(stderr, "Invalid database file\n");
    return 1;
}

fclose(fp);

    char *line = NULL;
    size_t cap = 0;
    ssize_t nread;

    while ((nread = getline(&line, &cap, stdin)) != -1) {
        if (nread > 0 && line[nread - 1] == '\n') {
            line[nread - 1] = '\0';
        }

        if (strncmp(line, "print", 5) == 0) {
            print_entries(head);
            continue;
        }

        if (strncmp(line, "add ", 4) == 0) {
            struct GradeEntry entry;
            if (!parse_add_argument(line + 4, &entry)) {
                printf("Invalid argument\n");
                continue;
            }

            if (entry_exists(head, entry.studentId, entry.assignmentName)) {
                printf("Duplicate entry\n");
                continue;
            }

            if (!append_entry(&head, &tail, &entry)) {
                free(line);
                fatal(head, "Memory allocation failed");
            }

            continue;
        }

        if (strcmp(line, "add") == 0) {
            printf("Invalid argument\n");
            continue;
        }

        if (strncmp(line, "remove ", 7) == 0) {
            char studentId[11];
            char assignmentName[21];

            if (!parse_remove_argument(line + 7, studentId, assignmentName)) {
                printf("Invalid argument\n");
                continue;
            }

            if (!remove_entry(&head, &tail, studentId, assignmentName)) {
                printf("Entry not found\n");
                continue;
            }

            continue;
        }

        if (strcmp(line, "remove") == 0) {
            printf("Invalid argument\n");
            continue;
        }

        if (strncmp(line, "stats ", 6) == 0) {
            const char *assignmentName = line + 6;

            if (!is_valid_assignment_name(assignmentName)) {
                printf("Invalid argument\n");
                continue;
            }

            if (!print_stats(head, assignmentName)) {
                printf("Entry not found\n");
                continue;
            }

            continue;
        }

        if (strcmp(line, "stats") == 0) {
            printf("Invalid argument\n");
            continue;
        }

        printf("Invalid command\n");
    }

    free(line);

    if (!save_database(dbPath, head)) {
        free_list(head);
        fprintf(stderr, "Failed to save database\n");
        return 1;
    }

    free_list(head);
    return 0;
}