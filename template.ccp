#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string>
#include <cstdio>
#include <cstdlib>
#include <ctime>

using namespace std;


// words.txt 파일에서 단어를 읽어오는 함수
int loadWords(string words[]) {
    FILE* fp = fopen("words.txt", "r");

    // 파일을 찾을 수 없는 경우
    if (fp == NULL) {
        cout << "no words.txt file found!\n";
        return 0;
    }

    char buf[16];
    int count = 0;

    // 파일에서 단어를 하나씩 읽어서 words 배열에 저장
    while (count < 1000 && fscanf(fp, "%15s", buf) == 1) {
        words[count] = buf;
        count++;
    }

    fclose(fp);

    return count;
}


int main() {
    string words[1000];

    // words.txt에서 단어 불러오기
    int count = loadWords(words);

    if (count == 0)
        return 0;


    // 랜덤 함수 초기화
    srand((unsigned)time(NULL));

    // 랜덤으로 정답 단어 선택
    string answer = words[rand() % count];


    // 이전에 입력한 단어와 결과를 저장하는 배열
    string guesses[6];
    string results[6];

    int guessCount = 0;
    bool win = false;
    bool giveup = false;


    // 최대 6번까지 단어 입력 가능
    while (guessCount < 6) {

        string guess;

        cout << "guess " << guessCount + 1 << ": ";
        cin >> guess;


        // giveup을 입력하면 포기
        if (guess == "giveup") {
            giveup = true;
            break;
        }


        // 5글자 단어인지 확인
        if (guess.length() != 5) {
            cout << "please enter a 5-letter word\n";
            continue;
        }


        string result = "-----";


        // 첫 번째 검사
        // 글자와 위치가 모두 맞으면 G
        for (int i = 0; i < 5; i++) {

            if (guess[i] == answer[i]) {
                result[i] = 'G';
            }
        }


        // 두 번째 검사
        // 글자는 있지만 위치가 다르면 Y
        for (int i = 0; i < 5; i++) {

            if (result[i] == 'G')
                continue;


            for (int j = 0; j < 5; j++) {

                if (i == j)
                    continue;


                if (guess[i] == answer[j]) {

                    // 해당 위치가 이미 G인지 확인
                    if (result[j] != 'G') {
                        result[i] = 'Y';
                        break;
                    }
                }
            }
        }


        // 입력한 단어와 결과 저장
        guesses[guessCount] = guess;
        results[guessCount] = result;


        // 검사 결과 출력
        cout << result << endl;


        // 정답을 맞혔는지 확인
        if (guess == answer) {
            win = true;
            guessCount++;
            break;
        }


        guessCount++;
    }


    // 정답을 맞힌 경우
    if (win) {
        cout << "you win!" << endl;
    }


    // 정답을 맞히지 못한 경우
    else {

        cout << "you lose! answer is: "
             << answer << endl;


        // 가능한 후보 단어
        int candidateCount = 0;
        string candidates[1000];


        // 모든 단어 확인
        for (int i = 0; i < count; i++) {

            bool possible = true;


            // 이전에 입력한 모든 단어와 비교
            for (int g = 0; g < guessCount; g++) {

                string testResult = "-----";


                // G 검사
                // 글자와 위치가 모두 같은 경우
                for (int a = 0; a < 5; a++) {

                    if (words[i][a] == guesses[g][a]) {
                        testResult[a] = 'G';
                    }
                }


                // Y 검사
                // 글자는 있지만 위치가 다른 경우
                for (int a = 0; a < 5; a++) {

                    if (testResult[a] == 'G')
                        continue;


                    for (int b = 0; b < 5; b++) {

                        if (a == b)
                            continue;


                        if (guesses[g][a] == words[i][b]) {

                            if (testResult[b] != 'G') {
                                testResult[a] = 'Y';
                                break;
                            }
                        }
                    }
                }


                // 이전 결과와 다르면 후보가 될 수 없음
                if (testResult != results[g]) {
                    possible = false;
                    break;
                }
            }


            // 가능한 단어를 후보 배열에 저장
            if (possible) {
                candidates[candidateCount] = words[i];
                candidateCount++;
            }
        }


        // 후보 단어 개수 출력
        cout << candidateCount << " candidates:" << endl;


        // 가능한 후보 단어 출력
        for (int i = 0; i < candidateCount; i++) {
            cout << candidates[i] << " ";
        }

        cout << endl;
    }


    return 0;
}
