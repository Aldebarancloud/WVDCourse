#Single Language setup
$Language1 = "fr-FR"
$UserLanguageList = New-WinUserLanguageList $Language1
Set-WinUserLanguageList -LanguageList $UserLanguageList
#Remplace the value after $Language1 by the value you want
#Go to language click on the package availabe and download it

#Multi language setup
$Language1 = "fr-FR"
$Language2 = "en-US"

$UserLanguageList = New-WinUserLanguageList $Language1
$UserLanguageList.Add($Language2)
Set-WinUserLanguageList -LanguageList $UserLanguageList
#Remplace the value after $Language1 and $Language2  by the value you want
#Go to language click on the package availabe and download them

# A small list of the common below the rest is on this link https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c
#de-DE	German-Germany
#de-CH German-Switzerland
#fr-CH	French-Switzerland
#en-US English-United States
#en-GB English-United Kingdom 
#it-IT	Italian-Italy
#en-IE	English-Ireland
#75	Czech Republic
#nn-NO	Norwegian (Nynorsk)-Norway
#fr-FR	French-France
#nl-NL	Dutch-Netherlands
#pt-PT Portuguese-Portugal
#es-ES	Spanish-Spain

