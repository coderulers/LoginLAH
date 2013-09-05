using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class LoginFirst : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
    {
        if (Membership.ValidateUser(Login1.UserName, Login1.Password))
        {
            MembershipUser mu = Membership.GetUser(Login1.UserName);
            Session["userID"] = mu.ProviderUserKey.ToString();
            Response.Redirect("Login.aspx");
        }
        else
        { 
            
        }
    }
}