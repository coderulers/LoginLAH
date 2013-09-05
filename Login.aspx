<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB4QyxUH_NE1Yz_5wZcHfLa1VG8cD35Gfo&sensor=false"></script>
    <script src="jquery.js"></script>
    <style>

        .hide {
            display: none;
        }
    </style>
</head> 
<body>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div>
            <div>
                Donate Portal
                <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" OnClientActiveTabChanged="Check">
                    <asp:TabPanel runat="server" HeaderText="Select Item" ID="TabPanel1">
                        <ContentTemplate>
                            <asp:DropDownList ID="DropDownList1" runat="server">
                            </asp:DropDownList>

                            Enter The Item Name
                             <asp:TextBox ID="itemname" runat="server"></asp:TextBox>
                            Enter The Item Description
                             <asp:TextBox ID="description" runat="server"></asp:TextBox>


                        </ContentTemplate>
                    </asp:TabPanel>
                    <asp:TabPanel ID="TabPanel2" runat="server" HeaderText="Schedule A Pickup">

                        <ContentTemplate>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="scheduleddate"></asp:CalendarExtender>
                            <asp:Label ID="Label1" runat="server" Text="Select Date">
                            </asp:Label><asp:TextBox ID="scheduleddate" runat="server"></asp:TextBox>

                        </ContentTemplate>
                    </asp:TabPanel>
                    <asp:TabPanel ID="TabPanel3" runat="server" HeaderText="Address" Height="450px">
                        <ContentTemplate>


                            <asp:Label ID="Label4" runat="server" Text="House No"></asp:Label>
                            <asp:TextBox ID="houseno" runat="server"></asp:TextBox><br />
                            <asp:Label ID="Label5" runat="server" Text="State"></asp:Label>
                            <asp:TextBox ID="state" runat="server"></asp:TextBox><br />




                            <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Always">
                                <ContentTemplate>
                                    <div id="map-canvas" style="width: 400px; height: 400px; z-index: 1; left: 711px; top: 50px; position: absolute;">
                                    </div>
                                    <div id="controls">
                                        <asp:Label ID="Label7" runat="server" Text="City"></asp:Label>
                                        <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource1" DataTextField="city" DataValueField="city" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList><br />
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:cityConnectionString %>" SelectCommand="SELECT DISTINCT [city] FROM [locality] ORDER BY [city]"></asp:SqlDataSource>
                                        <asp:Label ID="Label8" runat="server" Text="Locality"></asp:Label>
                                        <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDataSource2" DataTextField="locality" DataValueField="locality" OnSelectedIndexChanged="DropDownList3_SelectedIndexChanged" AutoPostBack="true" Width="400px"></asp:DropDownList><br />
                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:cityConnectionString2 %>" SelectCommand="SELECT DISTINCT [locality] FROM [locality] WHERE ([city] = @city) ORDER BY [locality]">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="DropDownList2" Name="city" PropertyName="SelectedValue" Type="String" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <asp:Label ID="Label6" runat="server" Text="Zip Code"></asp:Label>
                            <asp:TextBox ID="zipcode" runat="server"></asp:TextBox><br />



                            <asp:Button ID="Button3" runat="server" Text="Use My Address" OnClick="Button3_Click" />
                            <asp:Button ID="Button4" runat="server" Text="Submit" OnClick="Button4_Click" />
                        </ContentTemplate>
                    </asp:TabPanel>
                </asp:TabContainer>



                <asp:TextBox ID="latt" runat="server"></asp:TextBox>
                                <asp:TextBox ID="longt" runat="server"></asp:TextBox>
            </div>


            <div id="MyDonates">
                My Donations  
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>


            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:Button ID="Button5" runat="server" Text="My Donations" OnClick="Button5_Click" />
                </ContentTemplate>
            </asp:UpdatePanel>

            Track You Request
            <div id="TrackReq">
            </div>


            Search NGO Portal
            <div id="SearchNGO">
            </div>



        </div>
    </form>


    <script type="text/javascript">
        var map, markers = [], mycenter;
        // var lat = 28.6100;
        //var lng = 77.2300;

        var lat = "<%=lat%>";
        var lng = "<%=lng%>";
        var zoom1 = parseInt("<%=zoomcs%>", 10);


        mycenter = new google.maps.LatLng(lat, lng);


        function initializel(lat, lng, zomm1) {

            zoom1 = zomm1;
            mycenter = new google.maps.LatLng(lat, lng);

            initialize();

        }
        function initialize() {
            var mapOptions = {
                center: mycenter,
                zoom: zoom1,
                zoomControl: true,
                mapTypeControl: false,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            google.maps.event.addListener(map, 'click', function (event) { placeMarker(event.latLng); });
        }

        function placeMarker(location) {

            clearOverlays();
            $("#latt").val(location.lat());
            $("#longt").val(location.lng());


            var marker = new google.maps.Marker({
                position: location,
                map: map,
            });
            markers.push(marker);







        }
        function Check(sender, args) {
            if (sender.get_activeTabIndex() == 2) {
                initialize();
            }
        }
        function setAllMap(map) {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(map);
            }
        }

        function clearOverlays() {
            setAllMap(null);
        }



    </script>



</body>
</html>
