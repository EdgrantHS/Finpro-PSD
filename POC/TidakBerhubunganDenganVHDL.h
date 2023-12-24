/**
/**
 * @file TidakBerhubunganDenganVHDL.c
 * @brief This program contains function that doesn't relate to the VHDL.
 * @date 2023-11-18
 * @version 1.0
 * @note Created by Edgrant Henderson Suryajaya.
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct standard_logic_vector{
    int length;
    int *vector;
} std_logic_vector;

//alocate memory for the standard_logic_vector
void allocate(std_logic_vector *vector, int length){
    vector->length = length;
    vector->vector = (int *)malloc(length * sizeof(int));
}
