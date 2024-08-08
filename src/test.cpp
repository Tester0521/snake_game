#include <iostream>

#include <termios.h>
#include <unistd.h>

using namespace std;

int enable_raw_mode() {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    return 0;
}

int disable_raw_mode() {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    return 0;
}


int main() {

	char x = 0;

	enable_raw_mode();
	cin >> x;
	disable_raw_mode();

	cout << x;

}

