<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrLink.aspx.cs" Inherits="TrLink" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TrLink</title>
    <script src="js/jquery-3.1.0.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="DataTables/datatables.min.js"></script>
    <script src="js/bootstrap-multiselect.js"></script>
    <script src="js/bootstrap3-typeahead.min.js"></script>
    <script src="js/moment.js"></script>
    <script src="js/bootstrap-datepicker.min.js"></script>
    <script src="js/bootstrap-datetimepicker.js"></script>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="DataTables/datatables.min.css" rel="stylesheet" />
    <link href="css/bootstrap-multiselect.css" rel="stylesheet" />
    <link href="css/bootstrap-datetimepicker.css" rel="stylesheet" />
    <script src="http://cdnjs.cloudflare.com/ajax/libs/dropzone/3.8.4/dropzone.min.js"></script>
    <link href="css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <link href="http://cdnjs.cloudflare.com/ajax/libs/dropzone/3.8.4/css/dropzone.css" rel="stylesheet" />
    <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true&libraries=places&key=AIzaSyD62IxHK3Ews3H2fs9Pww97oTLB46t3srs"></script>



    <style type="text/css">
        .margin-top-20 {
            margin-top: 20px;
        }

        .dropzone {
            max-height: 250px !important;
        }

        #trlinkgrid_wrapper {
            margin-top: 10px;
        }

        #mapCanvas {
            width: 100%;
            height: 200px;
        }

        .col-md-2 > img {
            border: 2px solid lightgray;
        }

        a.boxclose {
            background-color: black;
            border: 2px solid lightgray;
            border-radius: 360px;
            color: white;
            cursor: pointer;
            margin-right: 40px !important;
            margin-top: -15px;
            padding: 2% 5%;
            position: absolute;
            right: 0;
            top: 0;
            text-decoration: none;
            cursor: pointer;
        }

        .boxclose:before {
            content: "X";
        }
    </style>

</head>
<body>
    <style>
        .row {
            margin-top: 1%;
        }

        .form-horizontal .form-group {
            padding: 0 15px;
        }

        .card-block::after {
            clear: both;
            content: "";
            display: table;
        }

        .card-block {
            padding: 1.25rem;
        }

        .card {
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, 0.125);
            border-radius: 0.25rem;
            display: block;
            margin-bottom: 0.75rem;
            position: relative;
        }

        #accordion .panel-heading {
            cursor: pointer;
        }
    </style>
 <%--   <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a href="#" class="navbar-brand">Restaurent Management</a>
            </div>
            <div class="navbar-collapse collapse" id="navbar">
                <ul class="nav navbar-nav">
                    <li><a href="Resturent.aspx">Restaurents</a></li>
                    <li class="active"><a href="TrLink.aspx">TrLinks</a></li>
                </ul> 
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>--%>
    <div class="container margin-top-20">
        <div id="divGrid">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">TrLink</h3>
                </div>
                <div class="panel-body">
                    <div class="form-inline">
                        <div class="form-group">
                            <label for="txtKeyword">Keyword:</label>
                            <input type="text" class="form-control" id="txtKeyword" />
                        </div>
                        <div class="form-group">
                            <label for="txtCity">City:</label>
                            <input type="text" class="form-control" id="txtCity" />
                        </div>
                        <div class="form-group">
                            <label for="txtFromDate">From:</label>
                            <input type="text" class="form-control" id="txtFromDate" />
                        </div>
                        <div class="form-group">
                            <label for="txtToDate">To:</label>
                            <input type="text" class="form-control" id="txtToDate" />
                        </div>
                        <div class="form-group">
                            <input type="button" class="form-control btn btn-default" id="btnSearch" onclick="getTrlinks()" value="Search" />
                        </div>
                    </div>
                    <table id="trlinkgrid" class="display table table-striped table-bordered" width="100%"></table>
                </div>
            </div>
        </div>
        <div id="divForm" style="display: none">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Restaurent Edit</h3>
                </div>
                <div class="panel-body">
                    <div class="row" style="margin-bottom: 2%">
                        <div class="col-md-12">
                            <div class="btn-group" style="margin-top: 1%; width: 100%">
                                <label style="color: red; float: left; font-weight: normal">* Click on labels to edit values</label>
                                <input type="button" style="margin-right: 2%" class="btn btn-danger pull-right" id="btnCancel" onclick="backTrLinks()" value="Back to list" />
                            </div>
                        </div>
                    </div>
                    <form id="frmEdit">
                        <div class="form-horizontal">
                            <input type="hidden" id="hdnUserId" />
                            <input type="hidden" id="hdnId" />
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtName">Name : </label>
                                            <input type="text" class="form-control" id="txtName" name="txtName" data-fieldname="Name" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtState">State : </label>
                                            <select id="txtState" name="txtState" data-fieldname="StateId" onchange="getCityByStateId($(this))" class="form-control"></select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtCityEdit">City : </label>
                                            <select id="txtCityEdit" data-fieldname="Cityid" name="txtCityEdit" class="form-control"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtOpeningTime">Opening Time : </label>
                                            <input type="text" class="form-control datepicker" data-fieldname="OpeningTime" id="txtOpeningTime" name="txtOpeningTime" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtClosingTime">Closing Time : </label>
                                            <input type="text" class="form-control datepicker" data-fieldname="ClosingTime" id="txtClosingTime" name="txtClosingTime" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtContactNo">Contact No : </label>
                                            <input type="text" class="form-control number" data-fieldname="ContactNumber" id="txtContactNo" name="txtContactNo" />
                                        </div>
                                        <span id="errContact" style="display: none; color: red">Contact number should be number</span>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label for="txtAddress">Address : </label>
                                            <input id="txtAddress" class="form-control" data-fieldname="Address" placeholder="Enter your address" type="text" name="txtAddress" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label for="txtLocation">Location : </label>
                                            <input id="txtLocation" class="form-control" data-fieldname="Location" placeholder="Enter your address" type="text" name="txtLocation" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="col-md-12">
                                        <div id="mapCanvas"></div>
                                    </div>
                                </div>
                            </div>
                            <hr />

                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtPinCode">PinCode : </label>
                                            <input type="text" class="form-control number" data-fieldname="PinCode" id="txtPinCode" name="txtPinCode" />
                                        </div>
                                        <span id="errPincode" style="display: none; color: red">Pincode should be number</span>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label for="txtWebAddress">Website Address : </label>
                                            <input type="text" data-fieldname="Website" class="form-control" id="txtWebAddress" name="txtWebAddress" />
                                        </div>
                                        <span id="errWebsite" style="display: none; color: red">Website Address should be url</span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtPrice">Price : </label>
                                            <input type="text" data-fieldname="MealPrice" class="form-control number" id="txtPrice" name="txtPrice" />
                                        </div>
                                        <span id="errPrice" style="display: none; color: red">Price number should be number</span>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="txtCuisine">Cuisine : </label>
                                            <select id="txtCuisine" multiple="multiple" class="multiselect" data-fieldname="Cuisine"></select>

                                            <%--                                            <input type="text" class="form-control" id="txtCuisine" name="txtCuisine" />--%>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="rdReservation">Reservation : </label>
                                            <div>
                                                <label style="font-weight: normal">
                                                    <input type="radio" name="rdReservation" value="Required" data-fieldname="Reservation" />
                                                    Required</label>
                                                <label style="font-weight: normal">
                                                    <input type="radio" name="rdReservation" value="NotRequired" data-fieldname="Reservation" />
                                                    Not Required</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="restauHighlights">Highlights : </label>
                                            <select id="restauHighlights" multiple="multiple" class="multiselect" data-fieldname="Cuisine"></select>
                                            <%--<div id="restauHighlights" style="border: 1px solid lightgray; padding: 4%; max-height: 200px; width: 60%; overflow: auto"></div>--%>
                                        </div>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label for="">Payment Method : </label>
                                            <br />
                                            <label style="font-weight: normal">
                                                <input type="checkbox" id="chckCash" class="payment" value="Cash" name="chckCash" data-fieldname="Payment" />
                                                Cash</label>
                                            <br />
                                            <label style="font-weight: normal">
                                                <input type="checkbox" id="chckCard" class="payment" value="Card Accepted" name="chckCard" data-fieldname="Payment" />
                                                Card Accepted</label>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-m-12">
                                    <div class="col-md-12">
                                        <div class="panel-group" id="accordion">
                                            <div class="panel panel-default">
                                                <div id="collapsetitle1" data-toggle="collapse" data-parent="#accordion" href="#collapse1" class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <a>Restaurent Menus</a>
                                                    </h4>
                                                </div>
                                                <div id="collapse1" class="panel-collapse collapse in">
                                                    <div class="panel-body">
                                                        <div id="fileMenus" class="dropzone">
                                                        </div>
                                                        <div class="col-md-12" style="margin-top: 10px">
                                                            <div class="panel panel-default">
                                                                <div class="panel-body" id="resMenus">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel panel-default">
                                                <div data-toggle="collapse" data-parent="#accordion" href="#collapse2" class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <a>Default Pics</a>
                                                    </h4>
                                                </div>
                                                <div id="collapse2" class="panel-collapse collapse">
                                                    <div class="panel-body">
                                                        <div id="fileDefaultPics" class="dropzone">
                                                        </div>

                                                        <div class="col-md-12" style="margin-top: 10px">
                                                            <div class="panel panel-default">
                                                                <div class="panel-body" id="resDefaultPics">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel panel-default">
                                                <div data-toggle="collapse" data-parent="#accordion" href="#collapse3" class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <a>All other resturent Pics </a>
                                                    </h4>
                                                </div>
                                                <div id="collapse3" class="panel-collapse collapse">
                                                    <div class="panel-body">
                                                        <div id="fileOtherPics" class="dropzone">
                                                        </div>
                                                        <div class="col-md-12" style="margin-top: 10px">
                                                            <div class="panel panel-default">
                                                                <div class="panel-body" id="resOtherPics">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel panel-default">
                                                <div data-toggle="collapse" data-parent="#accordion" href="#collapse4" class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <a>Resturent Documents </a>
                                                    </h4>
                                                </div>
                                                <div id="collapse4" class="panel-collapse collapse">
                                                    <div class="panel-body">
                                                        <div id="fileDocs" class="dropzone">
                                                        </div>

                                                        <div class="col-md-12" style="margin-top: 10px">
                                                            <div class="panel panel-default">
                                                                <div class="panel-body" id="resDocs">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
    <script src="js/trlink.js"></script>
    <script src="js/trlinkmap.js"></script>
</body>
</html>

