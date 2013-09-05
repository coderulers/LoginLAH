using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Net;
using System.IO;
using System.Configuration;
public partial class Login : System.Web.UI.Page
{

    public string lat = "20.0";
    public string lng = "77.0";
    public int zoomcs = 5;
    string constr = ConfigurationManager.ConnectionStrings["Somee"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        string[] cat ={ "Home & Lifestyle" ,
                          "Art - Collectibles - Hobbies",
                          "Books - Magazines",
                          "Clothing - Accessories",
                          "For Babies - Children",
                          "Health - Beauty",
                          "Furniture,Garden Supplies",
"Musical Instruments",
"Sports - Fitness Accessories ",
"Electronics & Technology ",
"Cameras or Accessories",
"CDs - DVDs",
"Computers,Laptops - Accessories",
"Home Appliance",
"Electronics Tools",
"Machinery - Industrial",
"Video Games - Consoles" ,
"Jobs & Services ",
"Job Offers",
"CVs Services"};
        DropDownList1.DataSource = cat;
        DropDownList1.DataBind();
    }


    protected void Button3_Click(object sender, EventArgs e)
    {
        //Take Address From DataBase if Exist
        SqlConnection sc = new SqlConnection("Connection String");
        SqlCommand sq = new SqlCommand("Command", sc);
        sc.Open();
        SqlDataAdapter s = new SqlDataAdapter(sq);
        DataSet ds = new DataSet();
        s.Fill(ds, "Address");
    }


    protected void Button4_Click(object sender, EventArgs e)
    {
        //Coding For Entering in database
        using (SqlConnection sc = new SqlConnection(constr))
        {
            string address = houseno.Text + ";" + DropDownList3.SelectedValue + ";" + DropDownList2.SelectedValue + ";" + state.Text + ";" + zipcode.Text + ";";
            string cmdtxt = "insert into request(userid,category,lock,startdate,title,description,ScheduleDate,Latitude,Longitude,Address)  values (@userid,@category,@lock,@startdate,@title,@description,@ScheduleDate,@Latitude,@Longitude,@Address)";
            SqlCommand sq = new SqlCommand(cmdtxt, sc);
            sq.Parameters.Add("@userid", Session["userID"].ToString());
            sq.Parameters.Add("@category", DropDownList1.SelectedIndex.ToString());
            sq.Parameters.Add("@lock", false);
            sq.Parameters.Add("@startdate", DateTime.UtcNow);
            sq.Parameters.Add("@title", itemname.Text);
            sq.Parameters.Add("@description", description.Text);
            sq.Parameters.Add("@ScheduleDate", scheduleddate.Text);
            sq.Parameters.Add("@Latitude",Convert.ToString(Convert.ToDouble(latt.Text)));
            sq.Parameters.Add("@Longitude", Convert.ToString(Convert.ToDouble(longt.Text)));
            sq.Parameters.Add("@Address", address);
            sc.Open();
            if (sc.State == ConnectionState.Open)
            {
                sq.ExecuteNonQuery();
                sc.Close();
            }
        }
    }
    protected void Button5_Click(object sender, EventArgs e)
    {
        //For loading donate post of user
        using (SqlConnection sc = new SqlConnection(constr))
        {
            SqlCommand sq = new SqlCommand("Select * from donated where userID='" + Session["userID"].ToString() + "'", sc);
            sc.Open();
            if (sc.State == ConnectionState.Open)
            {
                SqlDataReader t = sq.ExecuteReader();
                while (t.Read())
                {
                    HtmlGenericControl div = new HtmlGenericControl("div");
                    div.InnerHtml = t["title"].ToString();
                    PlaceHolder1.Controls.Add(div);
                }
                sc.Close();
            }

        }
    }

    protected void DropDownList3_SelectedIndexChanged(object sender, EventArgs e)
    {
        XmlReader reader = XmlReader.Create("http://maps.googleapis.com/maps/api/geocode/xml?address=" + DropDownList3.SelectedValue + " " + DropDownList2.SelectedValue + "india&sensor=false");
        while (reader.Read())
        {
            if (reader.IsStartElement("location"))
            {
                XmlReader sub = reader.ReadSubtree();
                while (sub.Read())
                {
                    if (sub.IsStartElement("lat"))
                    {
                        lat = sub.ReadElementContentAsString();
                        latt.Text = lat;
                    }
                    if (sub.IsStartElement("lng"))
                    {
                        lng = sub.ReadElementContentAsString();
                        longt.Text = lng;
                    }
                }
                break;
            }
        }
        zoomcs = 15;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "myscript", "initializel(" + lat + "," + lng + "," + zoomcs + ");", true);
    }
    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        lat = "20.0";
        lng = "77.0";
        zoomcs = 5;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "myscript", "initializel(" + lat + "," + lng + "," + zoomcs + ");", true);
    }
}