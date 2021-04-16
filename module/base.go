package module

type Translation struct {
	Language string
}

func NewTranslation(lan string) *Translation {
	return &Translation{
		Language: lan,
	}
}

func (t *Translation) Convert(text string) string {
	res := reverseString(text)
	return res
}
