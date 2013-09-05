using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    public WebService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string GiveLocal(string city)
    {
        string data = null;
        SqlConnection s = new SqlConnection(@"Data Source=.\sqlenterprise;Initial Catalog=city;Integrated Security=True");
        SqlCommand sc = new SqlCommand("Select locality from locality where city='" + city + "'", s);
        s.Open();
        SqlDataReader r;
        r = sc.ExecuteReader();

        while (r.Read())
        {
            data += r["locality"].ToString() + ",";
        }

        return data;

    }

}
