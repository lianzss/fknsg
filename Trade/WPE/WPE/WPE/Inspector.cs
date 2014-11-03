using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WPE
{
   public class Inspector
    {
        public static String Inspect(byte[] data)
        {
            return Inspect("", data, 16,true,true);
        }

        public static String Inspect(byte[] data, bool showHex, bool showString)
        {
            return Inspect("", data, 16, showHex, showString);
        }

        public static String Inspect(String label, byte[] data, int mode,bool showHex,bool showString)
        {
            if (data==null|| data.Length == 0)
                return "";
            StringBuilder buffer = new StringBuilder();
            //buffer.Append(">-----------------------------------------------------------------------------<\r\n");

            DateTime calendar = DateTime.Now;
            buffer.Append('[').Append(calendar.Hour);
            buffer.Append(':').Append(calendar.Minute);
            buffer.Append(':').Append(calendar.Second);
            buffer.Append(' ').Append(calendar.Millisecond).Append("]");
            buffer.Append(" size:").Append(data.Length).Append(" ");
            buffer.Append(label).Append("\r\n");



            int i = 0;
            for (; i < data.Length; i++)
            {
                int di = data[i] & 0xFF;
                String hex = di.ToString("X").ToUpper();
                if (showHex)
                {
                    if (hex.Length < 2)
                    {
                        buffer.Append('0');
                    }
                    buffer.Append(hex);
                    buffer.Append(' ');
                }
                if ((i + 1) % mode == 0)
                {
                    if (showString)
                    {
                        buffer.Append("   ");
                        for (int k = i - 15; k < i + 1; k++)
                        {
                            buffer.Append(toChar(data[k]));
                        }
                    }
                    buffer.Append("\r\n");
                }
            }

            int redex = mode - i % mode;
            for (byte k = 0; k < redex && redex < mode; k++)
            {
                if (showHex)
                {
                    buffer.Append("  ");
                    buffer.Append(' ');
                }
            }
            int count = i % mode;
            int start = i - count;
            if (start < i)
            {
                buffer.Append("   ");
            }
            for (int k = start; k < i; k++)
            {
                if (showString)
                {
                    buffer.Append(toChar(data[k]));
                }
            }

            if (redex < mode)
            {
                buffer.Append("\r\n");
            }
            buffer.Append("^-----------------------------------------------------------------------------^");

            return buffer.ToString();
        }

        static char toChar(byte b)
        {
            if (b == ' ')
                return ' ';

            if (b > 0x7E || b < 0x21 ||
                    b == ' ' || b == '\r')
                return '.';
            else
                return (char)b;
        }

    }
}
