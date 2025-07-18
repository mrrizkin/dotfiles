int
click_statuscmd(Bar *bar, Arg *arg, BarArg *a)
{
	return click_statuscmd_text(arg, a->x, rawstext);
}

int
click_statuscmd_text(Arg *arg, int rel_x, char *text)
{
	int i = -1;
	int x = 0;
  int ci = -1;
	char ch;
	statussig = -1;
	while (text[++i]) {
		if ((unsigned char)text[i] < ' ') {
			ch = text[i];
			text[i] = '\0';
			x += TEXTWM(text) - lrpad;
			text[i] = ch;
			text += i+1;
			i = -1;
			statussig = ++ci;
			if (x >= rel_x)
				break;
		}
	}
	return ClkStatusText;
}

void
copyvalidchars(char *text, char *rawtext)
{
	int i = -1, j = 0;

	while (rawtext[++i]) {
		if ((unsigned char)rawtext[i] >= ' ') {
			text[j++] = rawtext[i];
		}
	}
	text[j] = '\0';
}
