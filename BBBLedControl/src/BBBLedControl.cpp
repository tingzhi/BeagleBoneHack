//============================================================================
// Name        : BBBLedControl.cpp
// Author      : Tingzhi Li
// Version     :
// Copyright   : 
// Description : 
//============================================================================

#include <iostream>
#include <stdio.h>

using namespace std;

void sleep(int i) {
	for (int j = i; j > 0; j--) {
		for (int k = 10000; k > 0; k--) {
		}
	}
}

int main() {
	cout << "Start flashing LED-usr0" << endl;

	FILE *LEDHandle = NULL;
	char *LEDBrightness = "/sys/class/leds/beaglebone:green:usr0/brightness";

	for (int i = 0; i < 8; i++) {
		if ((LEDHandle = fopen(LEDBrightness, "r+"))!= NULL) {
			fwrite("1", sizeof(char), 1, LEDHandle);
			fclose(LEDHandle);
		}
		sleep(10000);

		if ((LEDHandle = fopen(LEDBrightness, "r+"))!= NULL) {
			fwrite("0", sizeof(char), 1, LEDHandle);
			fclose(LEDHandle);
		}
		sleep(10000);
	}

	cout << "Stop flashing LED-usr0" << endl;
	return 0;
}
