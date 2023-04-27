int main() {
    int i, j, k;

    // for loop
    for(i = 0; i < j; i++) {
        for(j = 0; j < k && j < 5; ++j, ++k)
            k = j;
    }

    // while loop
    while(i < j || i < k) {
        j--;
    }

    // do while loop
    do {
        i = k++;
        // nested while
        while(i < j)
            j--;
    }while(k <= 10);

    return 0;
}