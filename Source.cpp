#include <iostream>
using namespace std;

int stoi(char* str)	// return -1 mean NaN
{
	int num = 0;
	for (int i = 0; str[i] != '\0'; i++)
	{
		if (str[i] < '0' || str[i] > '9')
			return -1;
		num = num * 10 + (str[i] - '0');
	}
	return num;
}

int stoi(char* str, int maxLength)	// return -1 mean NaN
{
	int num = 0;
	int i = 0;
	Loop:
		if (str[i] == '\0' || i == maxLength)
			goto Exit;

		if (str[i] < '0' || str[i] > '9')
			return -1;
		num = num * 10 + (str[i] - '0');
		i++;
		goto Loop;
	Exit:
	return num;


	int x = rand();
}

void itos(int num, char* str)
{
	
}

bool leapyear(int year);

void input(int &day, int &month, int &year)
{
	begin:
	char sday[2], smonth[2], syear[4];
	cout << "Nhap ngay DAY: "; cin >> sday;
	day = stoi(sday);
	while (day < 1 || day > 31)
	{
		cout << "Khong hop le, nhap lai: "; cin >> sday;
		day = stoi(sday);
	}
	cout << "Nhap thang MONTH: "; cin >> month;
	while (month < 1 || month > 12)
	{
		cout << "Khong hop le, nhap lai: "; cin >> month;
	}
	cout << "Nhap nam YEAR: "; cin >> year;
	while (year < 1)
	{
		cout << "Khong hop le, nhap lai: "; cin >> year;
	}

	if (month == 4 || month == 6 || month == 9 || month == 11)
		if (day == 31)
		{
			cout << "Khong hop le, nhap lai: "; goto begin;
		}
	// nhuận thì có 29 ngày, ko nhuận thì có 28 ngày
	if (month == 2)
	{
		if (leapyear(year) == 0)
		{
			if (day > 28)
			{
				cout << "Khong hop le, nhap lai: "; goto begin;
			}
		}
		else if (day > 29)	// năm nhuận
		{
			{
				cout << "Khong hop le, nhap lai: "; goto begin;
			}
		}
	}

}

char* Date(int day, int month, int year, char* TIME);
char* Convert(char* TIME, char type);
int Day(char* TIME);
int Month(char* TIME);
int Year(char* TIME);
int LeapYear(char* TIME);
int GetTime(char* TIME_1, char* TIME_2);
char* Weekday(char* TIME);
void Find2LeapYearClosest(char* TIME, int &Prev, int &Next);
int main()
{
	MAIN_LOOP:
	int day, month, year;
	input(day, month, year);
	char TIME[20];
	Date(day, month, year, TIME);
	MENU_LOOP:
	cout << "--- MENU ---" << endl;
	cout << "0. Nhap lai ngay thang nam khac" << endl;
	cout << "1. Xuat theo dinh dang DD/MM/YYYY" << endl;
	cout << "2. Chuyen doi thanh cac dinh dang khac" << endl;
	cout << "3. Cho biet ngay vua nhap la thu may trong tuan" << endl;
	cout << "4. Kiem tra nam nhuan" << endl;
	cout << "5. Cho biet khoang thoi gian giua hai chuoi TIME_1 va TIME_2" << endl;
	cout << "6. Cho biet 2 nam nhuan gan nhat voi nam vua nhap" << endl;
	cout << "7. Thoat" << endl;
	int choose; cout << "Chon mot chuc nang: "; 
	CHOOSE_FEATURE: cin >> choose;
	switch (choose)
	{
	case 0:
		goto MAIN_LOOP;
	case 1:
		cout << TIME << endl;
		break;
	case 2:
		cout << "Chon kieu convert (A- MM/DD/YYYY | B- Month DD, YYYY | C- DD Month, YYYY): ";
		CHOOSE_TYPE: int type; cin >> type;
		switch (type)
		{
		case 'A': case 'B': case 'C':
			cout << Convert(TIME, type) << endl;
			break;
		default:
			cout << "Kieu ko hop le, chon lai: ";
			goto CHOOSE_TYPE;
		}
		break;
	case 3:
		cout << "Ngay vua nhap la thu " << Weekday(TIME) << endl;
		break;
	case 4:
		if (LeapYear(TIME))
			cout << "Dung la nam nhuan!" << endl;
		else
			cout << "Khong phai nam nhuan." << endl;
		break;
	case 5:
		cout << "Nhap ngay thang nam cho TIME2: " << endl;
		int day2, month2, year2;
		input(day2, month2, year2);
		char TIME2[20];
		Date(day2, month2, year2, TIME2);
		cout << "Khoang cach giua TIME1 va TIME2 la: " << GetTime(TIME1, TIME2) << endl;
		break;
	case 6:
		int prev, next;
		Find2LeapYearClosest(TIME, prev, next);
		cout << "Hai nam nhuan gan nhat la " << prev << " va " << next << endl;
		break;
	case 7: goto MAIN_EXIT;
	default:
		cout << "Kieu ko hop le, chon lai: ";
			goto CHOOSE_FEATURE;
	}
	goto MENU_LOOP;
	MAIN_EXIT:
}