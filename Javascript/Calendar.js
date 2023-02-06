// JS Calendar Array

function calendar(calendarDay)
{
	if(calendarDay == null) var calDate = new Date()
	else calDate = new Date(calendarDay);
	
	document.write("<table id='calendar_table'>");
		writeCalTitle(calDate);
		writeDayNames();
		writeCalDays(calDate);
	document.write("</table>");
}
	
function writeCalTitle(calendarDay)
{
	var monthName = new Array ("January", "February", "March", "April", "May",
		"June", "July", "August", "September", "October", "November", "December");
	var thisMonth = calendarDay.getMonth();
	var thisYear = calendarDay.getFullYear();
	
	document.write("<tr>");
	document.write("<th id='calendar_head' colspan='7'>");
	document.write(monthName[thisMonth] + " " + thisYear);
	document.write("</th>");
	document.write("</tr>");
}

function writeDayNames()
{
	var dayName = new Array("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat");
	
	document.write("<tr>");
	
	for(var i = 0; i < dayName.length; i++)
	{
		document.write("<th class='calendar_weekdays'>" + dayName[i] + "</th>");
	}
	
	document.write("</tr>");
}

function daysInMonth(calendarDay)
{
	var thisYear = calendarDay.getFullYear();
	var thisMonth = calendarDay.getMonth();
	
	var dayCount = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	
	if(thisYear % 4 == 0)
	{
		if((thisYear % 100 != 0) || (thisYear % 400 == 0))
		{
			dayCount[1] = 29;
		}
	}
	
	return dayCount[thisMonth];
}

function writeCalDays(calendarDay)
{
	var currentDay = calendarDay.getDate();		//stores the original "today" date
	var dayCount = 1;
	var totalDays = daysInMonth(calendarDay);
	calendarDay.setDate(1);						//reset calendar date to 1 for rendering
	var weekDay = calendarDay.getDay();			//0 for Sun, 1 for Mon, etc
	
	document.write("<tr>");
	
	//write blank cells preceding the first day of the month
	for(var i = 0; i < weekDay; i++)
	{
		document.write("<td>&nbsp;</td>");
	}
	
	//write the cells for each day of the month
	while(dayCount <= totalDays)
	{
		if(weekDay == 0) document.write("<tr>");	//write the table rows and cells
			
		
		if(dayCount ==  currentDay)		//highlight the current day
		{
			document.write("<td class='calendar_dates' id='calendar_today'>" + dayCount + "</td>");
		}
		
		else
		{
			document.write("<td class='calendar_dates'>" + dayCount + "</td>");
		}
		
		if(weekDay == 6) document.write("</tr>");
		
		//move to the next day
		dayCount++;
		calendarDay.setDate(dayCount);
		weekDay = calendarDay.getDay();
	}
	
	document.write("</tr>");
}