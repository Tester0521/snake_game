#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

int snickers(int *xy, int size, int x, int y) {
  for (int i = 0; i < size - 1; i += 2) {
    if (x == xy[i] && y == xy[i + 1])
      return 1;
  }
  return 0;
}

void vision(int *xy, int size, int aX, int aY) {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 20; j++) {
      if (snickers(xy, size, j - 2, i - 1))
        printf("@"); // (i == y + 1 && j == x + 2) printf("@");
      else if (i == aY + 1 && j == aX + 2)
        printf("*");
      else if (i == 0 || i == 9)
        printf("#");
      else
        (j > 0 && j < 19) ? printf(" ") : printf("#");
    }

    printf("\n");
  }
}

void aSpawn(int *aX, int *aY, int *xy, int size) {
  *aX = rand() % 17, *aY = rand() % 8;
  while ((*aX % 2 != 0 && snickers(xy, size, *aX, *aY)) || *aX % 2 != 0 ||
         snickers(xy, size, *aX, *aY))
    *aX = rand() % 17;
}

void upgrade(int **xy, int *size) {
  int newSize = *size + 2;
  *size = newSize;
  (*xy) = realloc(*xy, sizeof(int) * newSize);
  (*xy)[newSize - 2] = -5;
  (*xy)[newSize - 1] = -5;
}

void move(int **xy, int size, int x, int y) {

  for (int i = 0; i < size - 1; i += 2) {
    (*xy)[size - i] = (*xy)[size - i - 2];
    (*xy)[size - i + 1] = (*xy)[size - i + 1 - 2];
  }

  (*xy)[0] += x;
  (*xy)[1] += y;
}

int main() {
  struct termios oldt, newt;
  tcgetattr(STDIN_FILENO, &oldt);
  newt = oldt;
  newt.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, TCSANOW, &newt);

  srand(time(NULL));

  int size = 6;
  int x = 2, y = 0;
  int *xy = (int *)malloc(sizeof(int) * size);
  xy[0] = 0;
  xy[1] = 0;
  xy[2] = -1, xy[3] = -1, xy[4] = -2, xy[5] = -2;

  int aX = rand() % 17, aY = rand() % 8;
  while (aX % 2 != 0)
    aX = rand() % 17;

  while (1) {
    // system("clear");
    vision(xy, size, aX, aY);
    char c = getchar();

    switch (c) {
    case 'w':
      x = 0, y = -1;
      break;
    case 'a':
      x = -2, y = 0;
      break;
    case 's':
      x = 0, y = 1;
      break;
    case 'd':
      x = 2, y = 0;
      break;
    }
    move(&xy, size, x, y);

    if (xy[0] == aX && xy[1] == aY) {
      upgrade(&xy, &size);
      aSpawn(&aX, &aY, xy, size);
    }
    if (c == 'q' || (xy[0] < 0) || (xy[1] < 0) || (xy[1] > 7) || (xy[0] > 16))
      break;
  }
  printf("LOSER! (:");
}
