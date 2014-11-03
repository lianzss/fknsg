using System.Text;
using System.Net;
using System;
using System.Web;
using System.Collections.Specialized;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using Microsoft.Win32;
using System.Globalization;
using System.Threading;

namespace Auxiliary
{
    [Serializable]
    public class HttpClient : WebClient
    {
        // Cookie 容器
        private CookieContainer cookieContainer;
        private bool allowAutoRedirect = true;
        /// <summary>
        /// 创建一个新的 WebClient 实例。
        /// </summary>
        public HttpClient()
        {
            this.cookieContainer = new CookieContainer();
            cookie2 = new NameValueCollection();
            FormField = new NameValueCollection();
            Content = "";
            Proxy = null;
        }

        /// <summary>
        /// 创建一个新的 WebClient 实例。
        /// </summary>
        /// <param name="cookie">Cookie 容器</param>
        public HttpClient(CookieContainer cookies)
        {
            this.cookieContainer = cookies;
        }

        /// <summary>
        /// Cookie 容器
        /// </summary>
        public CookieContainer Cookies
        {
            get { return this.cookieContainer; }
            set { this.cookieContainer = value; }
        }


        private void BugFix_CookieDomain()
        {
            System.Type _ContainerType = typeof(CookieContainer);
            Hashtable table = (Hashtable)_ContainerType.InvokeMember("m_domainTable",
                                       System.Reflection.BindingFlags.NonPublic |
                                       System.Reflection.BindingFlags.GetField |
                                       System.Reflection.BindingFlags.Instance,
                                       null,
                                       cookieContainer,
                                       new object[] { });
            ArrayList keys = new ArrayList(table.Keys);
            foreach (string keyObj in keys)
            {
                string key = (keyObj as string);
                if (key[0] == '.')
                {
                    string newKey = key.Remove(0, 1);
                    table[newKey] = table[keyObj];
                }
            }
        }

        public List<Cookie> GetAllCookies()
        {
            CookieContainer cc = cookieContainer;
            List<Cookie> lstCookies = new List<Cookie>();

            Hashtable table = (Hashtable)cc.GetType().InvokeMember("m_domainTable",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.GetField |
                System.Reflection.BindingFlags.Instance, null, cc, new object[] { });

            foreach (object pathList in table.Values)
            {
                SortedList lstCookieCol = (SortedList)pathList.GetType().InvokeMember("m_list",
                    System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.GetField
                    | System.Reflection.BindingFlags.Instance, null, pathList, new object[] { });
                foreach (CookieCollection colCookies in lstCookieCol.Values)
                    foreach (Cookie c in colCookies)
                    {
                        //c.Path = "/";

                        c.Domain = ".taobao.com";
                        lstCookies.Add(c);

                    }
            }

            return lstCookies;
        }

        void SetHeader()
        {
            //this.Headers.Set("User-Agent", "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)");
            //this.Headers.Set("Accept", "text/html,application/xhtml+xml,application/xml;image/png,image/*;q=0.9,*/*;q=0.8");
            //this.Headers.Set("Accept-Language", "zh-cn,zh;q=0.5");
            //this.Headers.Set("Accept-Charset", "gb2312,utf-8;q=0.7,*;q=0.7");
            //this.Headers.Set("Keep-Alive", "300");
            //this.Headers.Remove("Content-Length");

            this.Headers.Set("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1");
            this.Headers.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
            this.Headers.Set("Accept-Language", "zh-cn,zh;q=0.5");
            this.Headers.Set("Accept-Charset", "gb2312,utf-8;q=0.7,*;q=0.7");
            this.Headers.Set("Accept-Charset", "gb2312,utf-8;q=0.7,*;q=0.7");
            //this.Headers.Set("Keep-Alive", "300");
            this.Headers.Remove("Content-Length");

        }

        //public string UrlEncode(string str, Encoding encoding)
        //{
        //    return HttpUtility.UrlEncode(str, encoding);
        //}

        //public string UrlDncode(string str, Encoding encoding)
        //{
        //    return HttpUtility.UrlDecode(str, encoding);
        //}

        public byte[] DownloadData(string uri, string reffer)
        {
            this.Headers.Set("Referer", reffer);
            byte[] data = base.DownloadData(uri);
            this.Headers.Set("Referer", "");
            return data;
        }

        public string DownloadString(string uri, string reffer)
        {

            this.Headers.Set("Referer", reffer);
            Content = DownloadString(uri);
            this.Headers.Set("Referer", "");
            return Content;
        }

        public void DownloadFile(string uri, string file, string reffer)
        {

            this.Headers.Set("Referer", reffer);
            DownloadFile(uri, file);
            this.Headers.Set("Referer", "");
        }

        public string DownloadString(string uri)
        {

            Content = base.DownloadString(uri);

            return Content;
        }

        public string DownloadString2(Uri uri)
        {
            Content = base.DownloadString(uri);
            return Content;
        }

        public string DownloadString(Uri uri)
        {
            Thread.Sleep(500);

            Byte[] data = base.DownloadData(uri);
            Content = Encoding.GetEncoding("utf-8").GetString(data);

            return Content;
        }

        public string DownloadString(Uri uri, string reffer)
        {
            this.Headers.Set("Referer", reffer);
            Byte[] data = base.DownloadData(uri);
            Content = Encoding.GetEncoding("utf-8").GetString(data);
            this.Headers.Set("Referer", "");
            return Content;
        }

        public bool IsContain(string substr)
        {
            return Content.Contains(substr);
        }

        /// <summary>
        /// 页面是否允许自动跳转，302代码
        /// </summary>
        public bool AllowAutoRedirect
        {
            set { allowAutoRedirect = value; }
            get { return allowAutoRedirect; }
        }
        /// <summary>
        /// 当前页面内容
        /// </summary>
        public string Content
        {
            get;
            set;
        }

        public string GetTextFromRegex(string regex, string content, int index)
        {
            Regex reg = new Regex(regex, RegexOptions.Multiline);
            MatchCollection mc = reg.Matches(content);
            if ((mc.Count - 1) >= index)
            {
                return mc[index].Value;
            }
            return "";
        }

        public NameValueCollection FormField
        {
            get;
            set;
        }

        public NameValueCollection GetFormField(string htm, string regex, int nameindex, int valueindex)
        {
            //if (null == FormField)
            FormField = new NameValueCollection();
            string inputexp = regex;// "(?i)<input[^<>]+name[ ]?=[ ]?[\"'](.*?)[\"']([^<>]+value[ ]?=[ ]?[\"'](.*?)[\"'])?";
            Regex regex2 = new Regex(inputexp, RegexOptions.Multiline);
            MatchCollection mc = regex2.Matches(htm);
            foreach (Match m in mc)
            {

                //MessageBox.Show(m.Groups[nameindex].Value + ":" + m.Groups[valueindex].Value);
                if (FormField[m.Groups[1].Value] != null)
                    FormField.Set(m.Groups[nameindex].Value, m.Groups[valueindex].Value);
                else
                    FormField.Add(m.Groups[nameindex].Value, m.Groups[valueindex].Value);
            }
            return FormField;
        }

        public String GetFormFieldSTR()
        {
            StringBuilder sb = new StringBuilder();
            foreach (string key in FormField.AllKeys)
            {
                sb.Append(key + "=" + FormField[key] + "&");//UrlEncode(FormField[key],Encoding.UTF8) + "&");
            }
            return sb.ToString();
        }

        //void UpdateetPost(string htm, PostData ps)
        //{
        //    ps.nc.Clear();
        //    string inputexp = "(?i)<input[^<>]+name[ ]?=[ ]?[\"'](.*?)[\"']([^<>]+value[ ]?=[ ]?[\"'](.*?)[\"'])?";
        //    Regex regex2 = new Regex(inputexp, RegexOptions.Multiline);
        //    MatchCollection mc = regex2.Matches(htm);
        //    foreach (Match m in mc)
        //    {
        //        if (ps.nc[m.Groups[1].Value] != null)
        //            ps.Set(m.Groups[1].Value, m.Groups[3].Value);
        //        else
        //            ps.Add(m.Groups[1].Value, m.Groups[3].Value);
        //    }
        //}

        /// <summary>
        /// 返回带有 Cookie 的 HttpWebRequest。
        /// </summary>
        /// <param name="address"></param>
        /// <returns></returns>
        protected override WebRequest GetWebRequest(System.Uri address)
        {

            int timeout = 10;
            BugFix_CookieDomain();
            getcookies(address);
            //MessageBox.Show(address.ToString());
            WebRequest request = base.GetWebRequest(address);

            //MessageBox.Show(request.RequestUri.ToString());
            if (request is HttpWebRequest)
            {
                HttpWebRequest httpRequest = request as HttpWebRequest;
                httpRequest.Timeout = 1000 * timeout;
                httpRequest.ReadWriteTimeout = 1000 * timeout;
                httpRequest.AllowAutoRedirect = allowAutoRedirect;
                httpRequest.CookieContainer = cookieContainer;

            }
            return request;
        }



        protected override WebResponse GetWebResponse(WebRequest request)
        {
            try
            {
                WebResponse response = base.GetWebResponse(request);
                TargetAdress = response.ResponseUri;
                //MessageBox.Show(TargetAdress.ToString());
                return response;
            }
            catch (Exception e)
            {
                return null;
            }

        }


        public NameValueCollection cookie2 { get; set; }
        public void getcookies(Uri uri)
        {
            foreach (Cookie c in this.Cookies.GetCookies(uri))
            {
                if (cookie2.Get(c.Name) == null)
                    cookie2.Add(c.Name, c.Value);
                else
                    cookie2.Set(c.Name, c.Value);
            }
        }

        public Uri TargetAdress;


        #region 封装了PostData, GetSrc 和 GetFile 方法
        /// <summary>
        /// 向指定的 URL POST 数据，并返回页面
        /// </summary>
        /// <param name="uriString">POST URL</param>
        /// <param name="postString">POST 的 数据</param>
        /// <param name="postStringEncoding">POST 数据的 CharSet</param>
        /// <param name="dataEncoding">页面的 CharSet</param>
        /// <returns>页面的源文件</returns>
        public string PostData(string uriString, string postString, string postStringEncoding, string dataEncoding, string reffer, out string msg)
        {
            //try
            //{
            this.Headers.Set("Referer", reffer);
            // 将 Post 字符串转换成字节数组
            byte[] postData = Encoding.GetEncoding(postStringEncoding).GetBytes(postString);
            this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            //this.Headers.Add("Content-Length", postData.Length.ToString());
            // 上传数据，返回页面的字节数组
            byte[] responseData = this.UploadData(uriString, "POST", postData);
            // 将返回的将字节数组转换成字符串(HTML);
            string srcString = Encoding.GetEncoding(dataEncoding).GetString(responseData);
            srcString = srcString.Replace("\t", "");
            srcString = srcString.Replace("\r", "");
            srcString = srcString.Replace("\n", "");
            msg = string.Empty;
            Content = srcString;
            this.Headers.Set("Referer", "");
            return srcString;
            //}
            //catch (WebException we)
            //{
            //    msg = we.Message;
            //    Content = "";
            //    return string.Empty;
            //}
        }





        /// <summary>
        /// 向指定的 URL POST 数据，并返回页面
        /// </summary>
        /// <param name="uriString">POST URL</param>
        /// <param name="postString">POST 的 数据</param>
        /// <param name="postStringEncoding">POST 数据的 CharSet</param>
        /// <param name="dataEncoding">页面的 CharSet</param>
        /// <returns>页面的源文件</returns>
        public byte[] PostData2(string uriString, string postString, string postStringEncoding, string dataEncoding, string reffer, out string msg)
        {
            try
            {
                this.Headers.Set("Referer", reffer);
                // 将 Post 字符串转换成字节数组
                byte[] postData = Encoding.GetEncoding(postStringEncoding).GetBytes(postString);
                this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                //this.Headers.Add("Content-Length", postData.Length.ToString());
                // 上传数据，返回页面的字节数组
                byte[] responseData = this.UploadData(uriString, "POST", postData);
                msg = "";
                return responseData;
            }
            catch (WebException we)
            {
                msg = we.Message;
                return null;
            }
        }


        /// <summary>
        /// 获得指定 URL 的源文件
        /// </summary>
        /// <param name="uriString">页面 URL</param>
        /// <param name="dataEncoding">页面的 CharSet</param>
        /// <returns>页面的源文件</returns>
        public string GetSrc(string uriString, string dataEncoding, out string msg)
        {
            try
            {
                // 返回页面的字节数组
                byte[] responseData = this.DownloadData(uriString);
                // 将返回的将字节数组转换成字符串(HTML);
                string srcString = Encoding.GetEncoding(dataEncoding).GetString(responseData);
                srcString = srcString.Replace("\t", "");
                srcString = srcString.Replace("\r", "");
                srcString = srcString.Replace("\n", "");
                msg = string.Empty;
                Content = srcString;
                return srcString;
            }
            catch (WebException we)
            {
                msg = we.Message;
                return string.Empty;
            }
        }

        /// <summary>
        /// 从指定的 URL 下载文件到本地
        /// </summary>
        /// <param name="uriString">文件 URL</param>
        /// <param name="fileName">本地文件的完成路径</param>
        /// <returns></returns>
        public bool GetFile(string urlString, string fileName, out string msg)
        {
            try
            {
                this.DownloadFile(urlString, fileName);
                msg = string.Empty;
                return true;
            }
            catch (WebException we)
            {
                msg = we.Message;
                return false;
            }
        }
        #endregion

        /// <summary>
        /// Uploads a stream using a multipart/form-data POST.
        /// </summary>
        /// <param name="requestUri"></param>
        /// <param name="postData">A NameValueCollection containing form fields 
        /// to post with file data</param>
        /// <param name="fileData">An open, positioned stream containing the file data</param>
        /// <param name="fileName">Optional, a name to assign to the file data.</param>
        /// <param name="fileContentType">Optional. 
        /// If omitted, registry is queried using <paramref name="fileName"/>. 
        /// If content type is not available from registry, 
        /// application/octet-stream will be submitted.</param>
        /// <param name="fileFieldName">Optional, 
        /// a form field name to assign to the uploaded file data. 
        /// If omitted the value 'file' will be submitted.</param>
        /// <param name="cookies">Optional, can pass null. Used to send and retrieve cookies. 
        /// Pass the same instance to subsequent calls to maintain state if required.</param>
        /// <param name="headers">Optional, headers to be added to request.</param>
        /// <returns></returns>
        /// Reference: 
        /// http://tools.ietf.org/html/rfc1867
        /// http://tools.ietf.org/html/rfc2388
        /// http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.2
        /// 
        public void PostFile
        (Uri requestUri, NameValueCollection postData, Stream fileData, string fileName,
                string fileContentType, string fileFieldName,
        NameValueCollection headers, string userAgent)
        {
            HttpWebRequest webrequest = (HttpWebRequest)WebRequest.Create(requestUri);

            string ctype;

            fileContentType = string.IsNullOrEmpty(fileContentType)
                                  ? TryGetContentType(fileName, out ctype) ?
                    ctype : "application/octet-stream"
                                  : fileContentType;

            fileFieldName = string.IsNullOrEmpty(fileFieldName) ? "file" : fileFieldName;
            if (!string.IsNullOrEmpty(userAgent))
                webrequest.UserAgent = userAgent;
            if (headers != null)
            {
                // set the headers
                foreach (string key in headers.AllKeys)
                {
                    string[] values = headers.GetValues(key);
                    if (values != null)
                        foreach (string value in values)
                        {
                            webrequest.Headers.Add(key, value);
                        }
                }
            }
            webrequest.Method = "POST";


            webrequest.CookieContainer = Cookies;


            string boundary = "----------" + DateTime.Now.Ticks.ToString
                        ("x", CultureInfo.InvariantCulture);

            webrequest.ContentType = "multipart/form-data; boundary=" + boundary;

            StringBuilder sbHeader = new StringBuilder();

            // add form fields, if any
            if (postData != null)
            {
                foreach (string key in postData.AllKeys)
                {
                    string[] values = postData.GetValues(key);
                    if (values != null)
                        foreach (string value in values)
                        {
                            sbHeader.AppendFormat("--{0}\r\n", boundary);
                            sbHeader.AppendFormat("Content-Disposition: form-data; name=\"{0}\";\r\n\r\n{1}\r\n", key,
                                                  value);
                        }
                }
            }

            if (fileData != null)
            {
                sbHeader.AppendFormat("--{0}\r\n", boundary);
                sbHeader.AppendFormat("Content-Disposition: form-data; name=\"{0}\"; {1}\r\n", fileFieldName,
                                      string.IsNullOrEmpty(fileName)
                                          ?
                                              ""
                                          : string.Format(CultureInfo.InvariantCulture,
                        "filename=\"{0}\";",
                                                          Path.GetFileName(fileName)));

                sbHeader.AppendFormat("Content-Type: {0}\r\n\r\n", fileContentType);
            }

            byte[] header = Encoding.UTF8.GetBytes(sbHeader.ToString());
            byte[] footer = Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
            long contentLength = header.Length + (fileData != null ?
                fileData.Length : 0) + footer.Length;

            webrequest.ContentLength = contentLength;

            using (Stream requestStream = webrequest.GetRequestStream())
            {
                requestStream.Write(header, 0, header.Length);


                if (fileData != null)
                {
                    // write the file data, if any
                    byte[] buffer = new Byte[checked((uint)Math.Min(4096,
                        (int)fileData.Length))];
                    int bytesRead;
                    while ((bytesRead = fileData.Read(buffer, 0, buffer.Length)) != 0)
                    {
                        requestStream.Write(buffer, 0, bytesRead);
                    }
                }

                // write footer
                requestStream.Write(footer, 0, footer.Length);

                WebResponse webresponse = webrequest.GetResponse();

                System.IO.Stream respStream = webresponse.GetResponseStream();

                System.IO.StreamReader respStreamReader = new StreamReader(respStream, Encoding.UTF8);

                String strBuff = "";

                char[] cbuffer = new char[256];

                int byteRead = 0;
                byteRead = respStreamReader.Read(cbuffer, 0, 256);

                while (byteRead != 0)
                {

                    String strResp = new String(cbuffer, 0, byteRead);

                    strBuff = strBuff + strResp;

                    byteRead = respStreamReader.Read(cbuffer, 0, 256);

                }

                respStream.Close();
                Content = strBuff;
            }
        }





        /// <summary>
        /// Uploads a file using a multipart/form-data POST.
        /// </summary>
        /// <param name="requestUri"></param>
        /// <param name="postData">A NameValueCollection containing 
        /// form fields to post with file data</param>
        /// <param name="fileName">The physical path of the file to upload</param>
        /// <param name="fileContentType">Optional. 
        /// If omitted, registry is queried using <paramref name="fileName"/>. 
        /// If content type is not available from registry, 
        /// application/octet-stream will be submitted.</param>
        /// <param name="fileFieldName">Optional, a form field name 
        /// to assign to the uploaded file data. 
        /// If omitted the value 'file' will be submitted.</param>
        /// <param name="cookies">Optional, can pass null. Used to send and retrieve cookies. 
        /// Pass the same instance to subsequent calls to maintain state if required.</param>
        /// <param name="headers">Optional, headers to be added to request.</param>
        /// <returns></returns>
        public void PostFile
        (Uri requestUri, NameValueCollection postData, string fileName,
             string fileContentType, string fileFieldName,
             NameValueCollection headers, string useragent)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                PostFile(requestUri, postData, null,
           fileName, fileContentType, fileFieldName,
                               headers, useragent);

                return;
            }

            using (FileStream fileData = File.Open
            (fileName, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                PostFile(requestUri, postData, fileData,
           fileName, fileContentType, fileFieldName,
                               headers, useragent);
            }
        }
        /// <summary>
        /// Attempts to query registry for content-type of supplied file name.
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="contentType"></param>
        /// <returns></returns>
        public bool TryGetContentType(string fileName, out string contentType)
        {
            try
            {
                RegistryKey key = Registry.ClassesRoot.OpenSubKey
                    (@"MIME\Database\Content Type");

                if (key != null)
                {
                    foreach (string keyName in key.GetSubKeyNames())
                    {
                        RegistryKey subKey = key.OpenSubKey(keyName);
                        if (subKey != null)
                        {
                            string subKeyValue = (string)subKey.GetValue("Extension");

                            if (!string.IsNullOrEmpty(subKeyValue))
                            {
                                if (string.Compare(Path.GetExtension
                    (fileName).ToUpperInvariant(),
                                         subKeyValue.ToUpperInvariant(),
                    StringComparison.OrdinalIgnoreCase) ==
                                    0)
                                {
                                    contentType = keyName;
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
            // ReSharper disable EmptyGeneralCatchClause
            catch
            {
                // fail silently
                // TODO: rethrow registry access denied errors
            }
            // ReSharper restore EmptyGeneralCatchClause
            contentType = "";
            return false;
        }
    }
}
