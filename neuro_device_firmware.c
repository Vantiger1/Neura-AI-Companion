#include <stdio.h>
#include <string.h>

void process_command(const char *cmd) {
    if (strcmp(cmd, "GET_HEART_RATE") == 0) {
        printf("{\"heartRate\": 72}\n");
    }
}

int main() {
    char buffer[64];
    while (fgets(buffer, sizeof(buffer), stdin)) {
        process_command(buffer);
    }
    return 0;
}