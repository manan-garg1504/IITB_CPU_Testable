#include<iostream>
#include<fstream>
#include<string>
using namespace std;

//this code assumes perfect assembly code
string to_bin(int n, int len)
{
    string ans = "";
    
    for(int i = 0; i < len; i++)    
    {    
        ans = to_string(n%2) + ans;    
        n = n/2;  
    }

    return ans;
}

void write_file(string file)
{
    ifstream start;
    start.open(file);
    string line;

    while(getline(start,line))
        cout << line << endl;

    start.close();
}

int main()
{
    
    freopen("code.txt", "r", stdin);
    freopen("memory.vhdl", "w", stdout);
    
    string opcode, R;
    int i = 0, imm = 0;

    write_file(".\\Testing\\start.txt");

    while(!feof(stdin))
    {
        cin >> opcode;
        cout << i << " => \"";

        if(opcode == "ADD" or opcode == "ADC" or opcode == "ADZ"
         or opcode == "NDU" or opcode == "NDC" or opcode == "NDZ")
        {
            (opcode[0] == 'A')? cout << "0000":cout << "0010";
            for(int i = 0; i < 3; i++)
            {
                cin >> R;
                cout << to_bin(R[1] - 48, 3);
            }
            cout << "0";

            if((opcode[2] == 'D') or (opcode[2] == 'U'))
            {
                cout << "00";
            }
            else if(opcode[2] == 'C')
                cout << "10";
            else
                cout << "00";
        }

        else if(opcode == "ADI" or opcode == "SW" or opcode == "LW" or opcode == "JLR" or opcode == "BEQ")
        {
            if(opcode == "ADI")
                cout << "0001";
            else if(opcode == "LW")
                cout << "0100";
            else if(opcode == "SW")
                cout << "0101";
            else if(opcode == "BEQ")
                cout << "1100";
            else
                cout << "1001";

            for(int i = 0; i < 2; i++)
            {
                cin >> R;
                cout << to_bin(R[1] - 48, 3);
            }

            if(opcode == "JLR")
                cout << "000000";
            else{
                cin >> imm;
                cout << to_bin(imm,6);
            }
        }

        else if (opcode == "NUM"){
            cin >> imm;
            cout << to_bin(imm, 16);
        }

        else{
            if(opcode == "LHI")
                cout << "0011";
            else if(opcode == "LM")
                cout << "0110";
            else if(opcode == "SM")
                cout << "0111";
            else
                cout << "1000";
            
            cin >> R;
            cout << to_bin(R[1] - 48,3);

            if(opcode == "LM" or opcode == "SM")
            {
                cin >> R;
                cout <<"0" << R;
            }
            else
            {
                cin >> imm;
                cout << to_bin(imm, 9);
            }
        }

        cout <<"\","<< endl;
        i++;
    }

    cout << i << " => \"1111000000000000\"," << endl;

    write_file(".\\Testing\\end.txt");
}