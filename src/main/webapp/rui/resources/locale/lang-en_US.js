Rui.namespace('Rui.message.locale.en_US');
Rui.applyObject(Rui.message.locale.en_US, {
    locale: 'en_US',
    core: {
        monthInYear: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        monthInYear1Char: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
        shortMonthInYear: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        dayInWeek: ['Sunday', 'Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday'],
        shortDayInWeek: ['Sun', 'Mon', 'Tue', 'Wed','Thu', 'Fri', 'Sat'],
        weekdays1Char: ['S','M','T','W','T','F','S'],
        startWeekDay: 0,
        localeMonths: 'long',
        localeWeekdays: '1char',
        dateDelimiter: ',',//복수 날짜 구분자
        dateRangeDelimiter: '~',//범위 표시시 날짜 구분자, -은 날짜 구분자로 사용될 수 있으므로 사용하면 안된다.
        myLabelMonthSuffix: ' ',
        myLabelYearSuffix: '',
        calendarNavigatorLabelMonth: 'Month',
        calendarNavigatorLabelYear: 'Year',
        kor: 'Hangul',
        eng: 'English',
        num: 'Number'
    },
    base: {
        msg001: 'Required input item.',
        msg002: 'Enter without spaces.',
        msg003: 'Enter equal to @ digit.',
        msg004: 'Enter from @ to @',
        msg005: 'Enter numbers only.',
        msg006: 'Enter characters only.',
        msg007: 'Enter only numbers and letters.(Without spaces)',
        msg008: 'Enter only numbers and letters.(Including spaces)',
        msg009: 'Please enter at least @ characters.',
        msg010: 'Enter @ characters or less.',
        msg011: 'Enter the above @.',
        msg012: 'Enter @ or less.',
        msg013: 'Invalid year.',
        msg014: 'Is not a valid Social Security number.',
        msg015: 'Is not a valid business registration number.',
        msg016: 'Is not a valid date.',
        msg017: 'Invalid month.',
        msg018: 'Invalid day.',
        msg019: 'Invalid hour.',
        msg020: 'Invalid minute.',
        msg021: 'Invalid seconds.',
        msg022: 'Since @-@-@ should be.',
        msg023: '@-@-@ must be earlier.',
        msg024: 'Should be match in \'@\' format.\n  - #: character or number\n  - h, H: Hangul(\'H\' contains a space)\n  - A, Z: Character(\'Z\' contains a space)\n  - 0, 9: Number(\'9\' contains a space)',
        msg029: 'Enter as much as @ bytes. (@ Digits of Hangul)',
        msg030: 'Please enter at least @ byte characters. (Hangul characters that @)',
        msg031: 'Enter @ byte characters or less. (Hangul characters or less of the @)',
        //msg032: '----Undecided',
        msg033: '\'@\' Character can not be used.',
        msg034: 'Invalid email address.',
        msg035: 'Enter down to @ integer places.',
        msg036: 'Enter down to @ decimal places.',
        msg037: '\'@\' Enter in the format.',
        msg038: '\'@\' Character can be used only.',
        msg039: 'Must be selected more than one @.',
        msg040: 'Invalid time.',
        msg041: 'Can not move the record.',
        msg042: 'Prev',
        msg043: 'Next',
        msg044: 'Ok',
        msg050: 'Validator expression is invalid. (@)',
        msg051: 'Validator in the expression of the test item does not exist. (@)',
        msg052: 'Not valid.',
        msg100: 'The operation was successful.',
        msg101: 'The operation was failed.',
        msg102: 'No changes were made.',
        msg103: 'Can not find the page.',
        msg104: 'An unknown error has occurred.',
        msg105: 'Are you sure to create?',
        msg106: 'Are you sure to update?',
        msg107: 'Are you sure to delete?',
        msg108: 'Choose a state',
        msg109: 'Changes have been applied.',
        msg110: 'The server sent the unknown message.',
        msg111: 'Please enter your email address.',
        msg112: 'Response time has been exceeded.',
        msg113: 'Failed to save to the clipboard.',
        msg114: 'Browser\'s settings are not authorized to access the clipboard. required setting -> about: config',
        msg115: 'No Results',
        msg116: 'to large dataset error, Max row: @',
        msg117: 'After filtering, modified data will be initialized.',
        msg118: 'select date.',
        msg119: 'All',
        msg120: 'Apply',
        msg121: 'Cancel',
        msg122: 'SubTotal',
        msg123: 'Total',
        msg124: 'Close',
        msg125: 'Clipboard',
        msg126: 'It\'s the first.',
        msg127: 'It\'s the last.',
        msg128: 'Copy',
        msg129: 'Paste',
        msg130: '※ This browser can\'t access to the clipboard, so this dialog can be opened in the unsupported browser.<br/>Please copy/paste the text on this dialog.',
        msg131: 'Select download type. Total Count : [@]',
        msg132: 'When you don\'t use cell merge feature, the UI performance will be improved.',
        msg133: 'When you deal with mass data, please check [Not cell merge].',
        msg134: 'Use cell merge',
        msg135: 'Not cell merge',
        msg136: 'Calculate the number of cells',
        msg137: 'Except for the number of cells',
        msg138: 'Average',
        msg139: 'Calculation'
        // 이곳은 RichUI의 기본 메시지 라이브러리 입니다. 이 영역에 메시지를 추가하지 마세요.
    },
    ext: {
        msg001: 'Export Excel',
        msg002: 'Freeze column',
        msg003: 'Sort',
        msg004: 'Filter',
        msg005: 'Asc',
        msg006: 'Desc',
        msg007: 'Up to @ limited',
        msg008: 'Default menu',
        msg009: 'Column menu',
        msg010: 'Information',
        msg011: 'Custom column width (Data)',
        msg012: 'Column width',
        msg013: 'Clear filter',
        msg014: 'Does not apply',
        msg015: 'Custom column width (Grid)',
        msg016: 'We\'ve detected that you are using an unsupported browser.  Please <a href="http://browsehappy.com/">upgrade your browser</a> to Internet Explorer 9 or higher.',
        msg017: 'Data of @ exceed. On slow Do you want to proceed? ',
        msg018: 'Start Date.',
        msg019: 'End Date.',
        msg020: 'Choose the dates.',
        msg021: 'Search',
        msg022: 'Invalid Start & End Dates.',
        msg023: 'Choose a file.'
        // 이곳은 RichUI의 확장 메시지 라이브러리 입니다. 이 영역에 메시지를 추가하지 마시고 아래 'message' 영역에 추가하여 사용하세요.
    },
    message: {
        // 이곳에 프로젝트 공통 메시지를 추가하여 사용하세요.
    	sample: 'Custom Validator Sample Test Message',
        forProject: 'for @ Project'
    }
});

var configLocale = Rui.message.locale.en_US.core;

Rui.util.LDateLocale['en_US'] = Rui.merge(Rui.util.LDateLocale['en_US'], {
        a: configLocale.shortDayInWeek,
        A: configLocale.dayInWeek,
        b: configLocale.shortMonthInYear,
        B: configLocale.monthInYear1Char
});

Rui.message.locale.en_US.moneyFormat = function(v) {
    return Rui.util.LNumber.toMoney(v, '$');
};

Rui.message.locale.en_US.numberFormat = function(v) {
    return Rui.util.LNumber.format(v, { thousandsSeparator: ',' });
};
