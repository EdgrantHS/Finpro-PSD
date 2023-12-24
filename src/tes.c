#include <stdio.h>
#include <math.h>

#define PI 3.14159265
#define FU_SCALE 65536  // Scale for full circle (2π in radians)

// Convert radians to fixed-point units (fu)
int radToFu(float radInput){
    return (int)(radInput * FU_SCALE / (2 * PI));
}

// Fixed-point sine function using Taylor series
int fuSin(int fuInput) {
    long long sinOut, term;
    int i;

    // Initialize sinOut with the first term of the series
    sinOut = term = fuInput;

    // Calculate subsequent terms
    for (i = 1; i <= 15; i += 2) { // Increasing number of terms for accuracy
        term = -term * fuInput / FU_SCALE * fuInput / FU_SCALE / (i * (i + 1));
        sinOut += term;
    }

    return (int)sinOut;
}

float degreetorad(int degreeInput){
    return (float)degreeInput * PI / 180;
}

int main(){
    int degree, fuInput, sinOut;
    float radInput;

    printf("Enter the degree value: ");
    scanf("%d", &degree);

    radInput = degreetorad(degree);
    fuInput = radToFu(radInput);
    sinOut = fuSin(fuInput);

    printf("The sine value of %d degrees (in fu) is %f\n", degree, (float)sinOut / FU_SCALE);
    printf("The real value is %f\n", sin(radInput));

    return 0;
}
