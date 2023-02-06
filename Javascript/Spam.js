// Reverse chars in a string

function stringReverse(textString)
{
   if (!textString) return '';
   let revString='';
   for (let i = textString.length-1; i>=0; i--)
       revString+=textString.charAt(i)
   return revString;
}