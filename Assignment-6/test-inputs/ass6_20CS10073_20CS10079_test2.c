// Testing various functionalities through merge sort

int printStr (char *ch);
int printInt (int n);
int readInt (int *eP);

int merge (int arr[], int l, int m, int r) {    // Passing array as parameter
    int i, j, k;
    int n1 = m - l + 1;
    int n2 =  r - m; 
    int L[6], R[6];
 
    for(i = 0; i < n1; i++) {
        L[i] = arr[l + i];
    }
    for(j = 0; j < n2; j++) {
        int p = m + j + 1;
        R[j] = arr[p];
    }
 
    i = 0;
    j = 0;
    k = l;
    while (i < n1 && j < n2) {                  // Testing while loop
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        }
        else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
 
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
 
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }

    return 0;
}
 

void mergeSort (int arr[], int l, int r) {      // Testing void return type
    if (l < r) {
        int m = (l + r) / 2; 
        mergeSort(arr, l, m);                   // Testing recursion
        mergeSort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}

void printArray (int arr[], int n) {
    int i;
    for (i = 0; i < n; i++) {
        printInt(arr[i]);
        printStr(" ");
    }
    printStr("\n");
}
 
int main() {
    printStr("Merge Sort\n");
    
    int arr[6];
    arr[0] = 64;
    arr[1] = 21;
    arr[2] = 11;
    arr[3] = 15;
    arr[4] = 28;
    arr[5] = 9;
    int n = 6;
 
    printStr("Original array: \n");
    printArray(arr, n);
 
    mergeSort(arr, 0, n - 1);
 
    printStr("Sorted array: \n");
    printArray(arr, n);

    return 0;
}
