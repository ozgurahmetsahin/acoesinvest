/*
 * File:   addNewConnectionTest.c
 * Author: donda
 *
 * Created on Mar 8, 2011, 10:14:33 PM
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * Simple C Test Suite
 */

int addNewConnection(int fd);

void testAddNewConnection() {
    int fd=1;
    int result = addNewConnection(fd);
    if(1 /*check result*/) {
        printf("%%TEST_FAILED%% time=0 testname=testAddNewConnection (addNewConnectionTest) message=error message sample\n");
    }
}

int main(int argc, char** argv) {
    printf("%%SUITE_STARTING%% addNewConnectionTest\n");
    printf("%%SUITE_STARTED%%\n");

    printf("%%TEST_STARTED%%  testAddNewConnection (addNewConnectionTest)\n");
    testAddNewConnection();
    printf("%%TEST_FINISHED%% time=0 testAddNewConnection (addNewConnectionTest)\n");
    
    printf("%%SUITE_FINISHED%% time=0\n");

    return (EXIT_SUCCESS);
}
