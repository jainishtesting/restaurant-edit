﻿
var dt;
var menus = [];
var defaultpics = [];
var otherpics = [];
var docs = [];

$(function () {
    InitializeDataTable([]);
    getCity();
    //getRestaurants();
    $('#txtFromDate').datepicker({
        autoclose: true
    });
    $('#txtToDate').datepicker({
        autoclose: true
    });
    $(".datepicker").datetimepicker();
});
function InitializeDataTable(dataset) {
    dt = $('#resturantGrid').DataTable({
        data: dataset,
        "aoColumnDefs": [
            {
                "aTargets": [7],
                //"mData": "download_link",
                "mRender": function (data, type, full) {
                    if (data == true)
                        return '<input type="checkbox" class="tglCls" rel="' + full.Id + '" checked data-toggle="toggle" data-size="small" onchange="toggleIsActive(this)">';
                    else
                        return '<input type="checkbox" class="tglCls" rel="' + full.Id + '" data-toggle="toggle" data-size="small" >';
                }
            },
            {
                "aTargets": [8],
                "mRender": function (data, type, full) {
                    return '<a onclick="fnedit(' + data + ')"><i class="glyphicon glyphicon-pencil"></i></a><a style="margin-left:10px;" onclick="fndelete(' + data + ')"><i class="glyphicon glyphicon-remove"></i></a>'
                }
            }
        ],
        columns: [
            { data: "Name", title: "Name" },
            { data: "MainSubCategoryName", title: "City" },
            { data: "MainCategoryName", title: "State" },
            { data: "ContactNumber", title: "Contact Number" },
            { data: "ReceivedDate", title: "Received Date" },
            { data: "FullName", title: "Created by" },
            { data: "Status", title: "Status" },
            { data: "IsActive", title: "Active" },
            { data: "Id", title: "Action" }
        ],
        searching: false,
        ordering: false,
        paging: true
    });
}

function formatDate(dateVal) {
    var newDate = new Date(dateVal);

    var sMonth = padValue(newDate.getMonth() + 1);
    var sDay = padValue(newDate.getDate());
    var sYear = newDate.getFullYear();
    var sHour = newDate.getHours();
    var sMinute = padValue(newDate.getMinutes());
    var sAMPM = "AM";

    var iHourCheck = parseInt(sHour);

    if (iHourCheck > 12) {
        sAMPM = "PM";
        sHour = iHourCheck - 12;
    }
    else if (iHourCheck === 0) {
        sHour = "12";
    }

    sHour = padValue(sHour);

    return sMonth + "/" + sDay + "/" + sYear + " " + sHour + ":" + sMinute + " " + sAMPM;
}

function padValue(value) {
    return (value < 10) ? "0" + value : value;
}

function getRestaurants() {
    getStates();
    getHighLights();
    getCousines();

    var current = $('#txtCity').typeahead("getActive");
    var obj = {
        key: $('#txtKeyword').val(),
        cityid: (current != undefined && current.id != null && current.id != undefined && current.id != '') ? current.id : 0,
        fromdate: $('#txtFromDate').val(),
        todate: $('#txtToDate').val()
    }
    $.ajax({
        url: "Resturent.aspx/getRestaurants",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                ReloadDataTable(jsonres);
            }
        },
        error: function (e) {
        }
    });
}

function getCousines() {
    $.ajax({
        url: "Resturent.aspx/getCousines",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var restauHighlights = $('#txtCuisine');
                restauHighlights.empty();
                $.each(jsonres, function (i, ele) {
                    //restauHighlights.append("<input type='checkbox' class='restauHighlights' value='" + ele.id + "'> " + ele.name + "<br />");
                    restauHighlights.append("<option value='" + ele.name + "'> " + ele.name + "</option>");
                });
                $('#txtCuisine').multiselect({
                    buttonWidth: '100%',
                    includeSelectAllOption: true,
                    maxHeight: 200
                    //dropUp: true
                });
            }
        }
    });
}

function getHighLights() {
    $.ajax({
        url: "Resturent.aspx/getHighlights",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var restauHighlights = $('#restauHighlights');
                restauHighlights.empty();
                $.each(jsonres, function (i, ele) {
                    //restauHighlights.append("<input type='checkbox' class='restauHighlights' value='" + ele.id + "'> " + ele.name + "<br />");
                    restauHighlights.append("<option value='" + ele.id + "'> " + ele.name + "</option>");
                });
                $('#restauHighlights').multiselect({
                    buttonWidth: '100%',
                    includeSelectAllOption: true,
                    maxHeight: 200
                    //dropUp: true
                });
            }
        }
    });
}

function getHighlightsByRestau(restauId) {
    var obj = {
        restauId: restauId
    }
    $.ajax({
        url: "Resturent.aspx/getHighlightsByRestau",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            //$(".restauHighlights").each(function (i, ele) {
            //    $(ele).removeAttr("checked");
            //});
            $('#restauHighlights').multiselect('refresh');

            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var tmpArr = [];
                for (var i = 0; i < jsonres.length; i++) {
                    tmpArr.push(jsonres[i].id)
                }
                $('#restauHighlights').multiselect('select', tmpArr);
                //$(".restauHighlights").each(function (i, ele) {
                //    $.each(jsonres, function (i, ele1) {
                //        if (Number(ele1.id) === Number($(ele).val())) {
                //            $(ele).prop('checked', true);
                //        }
                //    });
                //});
            }
        }
    });
}

function deleteImage(obj) {
    console.log(obj);
    if (confirm("Are you sure want to delete")) {
        var rsid = $(obj).data("rsid");
        var type = $(obj).data("type");
        var deleteObj = {
            id: $(obj).data("rid"),
            type: $(obj).data("type"),
            path: $(obj).data("path")
        }

        $.ajax({
            url: "Resturent.aspx/RestaurantsDeleteImage",
            data: JSON.stringify(deleteObj),
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res != null && res.d != null && res.d != undefined) {
                    if (type === "menus") {
                        getRestauMenusByRestau(rsid);
                    } else if (type === "docs") {
                        getRestauDocsByRestau(rsid);
                    }
                    else {
                        getRestauPicsByRestau(rsid);
                    }
                }
            },
            error: function (e) {
            }
        });
    }
}

function getRestauMenusByRestau(restauId) {
    var obj = {
        restauId: restauId
    }
    $.ajax({
        url: "Resturent.aspx/getRestauMenusByRestau",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            $("#resMenus").html("");

            if (res != null && res.d != null && res.d != undefined) {
                var pics = JSON.parse(res.d);
                if (pics.length > 0) {
                    $.each(pics, function (i, ele) {
                        var div = $("<div class='col-md-2'>");
                        var a = $("<a></a>");
                        div.css("margin-top", "10px");

                        a.addClass("boxclose");
                        a.attr("onclick", "deleteImage(this)");
                        a.attr("data-type", "menus");
                        a.attr("data-path", ele.PhotoPath);
                        a.attr("data-rsid", restauId);
                        a.attr("data-rid", ele.PhotoNo);
                        a.attr("href", "javascript:;");

                        var image = $("<img  height='100' width='100'/>");
                        image.attr("src", ele.PhotoPath.replace("~", ""));
                        div.append(image);
                        div.append(a);
                        $("#resMenus").append(div);
                    });
                }
                else {
                    $("#resMenus").html("No Restaurent Menus");
                }
            }
            else {
                $("#resMenus").html("No Restaurent Menus");
            }
        }
    });
}

function getRestauDocsByRestau(restauId) {
    var obj = {
        restauId: restauId
    }
    $.ajax({
        url: "Resturent.aspx/getRestauDocsByRestau",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            $("#resDocs").html("");
            if (res != null && res.d != null && res.d != undefined) {
                var pics = JSON.parse(res.d);
                if (pics.length > 0) {
                    $.each(pics, function (i, ele) {
                        var div = $("<div class='col-md-2'>");
                        var a = $("<a></a>");
                        div.css("margin-top", "10px");

                        a.addClass("boxclose");
                        a.attr("onclick", "deleteImage(this)");
                        a.attr("data-type", "docs");
                        a.attr("data-path", ele.AbsolutePath);
                        a.attr("data-rsid", restauId);
                        a.attr("data-rid", ele.Id);
                        a.attr("href", "javascript:;");

                        var image = $("<img  height='100' width='100'/>");
                        image.attr("src", ele.AbsolutePath.replace("~", ""));
                        image.attr("alt", ele.FileName);

                        div.append(image);
                        div.append(a);
                        $("#resDocs").append(div);
                    });
                }
                else {
                    $("#resDocs").html("No Restaurent Documents");
                }
            }
            else {
                $("#resDocs").html("No Restaurent Documents");
            }
        }
    });
}

function getRestauPicsByRestau(restauId) {
    var obj = {
        restauId: restauId
    }
    $.ajax({
        url: "Resturent.aspx/getRestauPicsByRestau",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            $("#resDefaultPics").html("");
            $("#resOtherPics").html("");

            if (res != null && res.d != null && res.d != undefined) {
                var pics = JSON.parse(res.d);
                if (pics.length > 0) {
                    var isDefault = false;
                    var isOther = false;

                    $.each(pics, function (i, ele) {
                        console.log(ele);
                        var div = $("<div class='col-md-2'>");
                        var a = $("<a></a>");
                        div.css("margin-top", "10px");
                        a.addClass("boxclose");
                        a.attr("href", "javascript:;");
                        a.attr("data-rid", ele.Id);
                        a.attr("data-rsid", restauId);

                        a.attr("data-path", ele.AbsolutePath);
                        a.attr("data-type", "pics");
                        a.attr("onclick", "deleteImage(this)");
                        var image = $("<img  height='100' width='100' />");
                        image.attr("src", ele.AbsolutePath.replace("~", ""));
                        div.append(image);
                        div.append(a);

                        if (ele.IsDefault == true) {
                            $("#resDefaultPics").append(div);
                            if (isDefault == false) {
                                isDefault = true;
                            }
                        }
                        else {
                            $("#resOtherPics").append(div);
                            if (isOther == false) {
                                isOther = true;
                            }
                        }
                    });
                    if (!isDefault) {
                        $("#resDefaultPics").html("No Restaurent Pictures");
                    }
                    if (!isOther) {
                        $("#resOtherPics").html("No Restaurent Other Pictures");
                    }
                }
                else {
                    $("#resDefaultPics").html("No Restaurent Pictures");
                    $("#resOtherPics").html("No Restaurent Other Pictures");
                }
            }
            else {
                $("#resDefaultPics").html("No Restaurent Pictures");
                $("#resOtherPics").html("No Restaurent Other Pictures");
            }
        }
    });
}

function ReloadDataTable(dataset) {
    dt.clear();
    dt.rows.add(dataset).draw();
    $('.tglCls').bootstrapToggle();
    $('.tglCls').change(function () {
        var tmpid = $(this).attr('rel');
        var obj = {
            id: tmpid,
            active: $(this).prop('checked')
        }
        $.ajax({
            url: "Resturent.aspx/toggleActive",
            data: JSON.stringify(obj),
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res != null && res.d != null && res.d != undefined) {
                }
            },
            error: function (e) {
            }
        });
    })
}
function fnedit(id) {
    $("#divGrid").fadeOut();
    $("#divForm").fadeIn();
    if (mapLoad == false) {
        initialize();
    }
    var obj = {
        id: id
    }
    $.ajax({
        url: "Resturent.aspx/getRestaurentData",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                $("#hdnUserId").val($(jsonres)[0].UserId);
                $("#hdnId").val($(jsonres)[0].Id);
                $("#txtName").val($(jsonres)[0].Name);
                $("#txtState").val($(jsonres)[0].StateId);
                if ($(jsonres)[0].Reservation !== null) {
                    if ($(jsonres)[0].Reservation.replace(/ /g, '') !== "") {
                        $("input[name=rdReservation][value=" + $(jsonres)[0].Reservation.replace(/ /g, '') + "]").attr('checked', true);
                    }
                    else {
                        $('input[name="rdReservation"]').attr('checked', false);
                    }
                }

                getCityByStateId($("#txtState"));
                getHighlightsByRestau($(jsonres)[0].Id);
                getRestauMenusByRestau($(jsonres)[0].Id);
                getRestauDocsByRestau($(jsonres)[0].Id);
                getRestauPicsByRestau($(jsonres)[0].Id);

                var oDate = "";
                var cDate = "";
                if ($(jsonres)[0].OpeningTime !== null && $(jsonres)[0].OpeningTime !== undefined && $(jsonres)[0].OpeningTime !== "") {
                    oDate = formatDate($(jsonres)[0].OpeningTime)
                }
                if ($(jsonres)[0].ClosingTime !== null && $(jsonres)[0].ClosingTime !== undefined && $(jsonres)[0].ClosingTime !== "") {
                    cDate = formatDate($(jsonres)[0].ClosingTime)
                }
                $("#txtCityEdit").val($(jsonres)[0].Cityid);
                $("#txtOpeningTime").val(oDate);
                $("#txtClosingTime").val(cDate);
                $("#txtAddress").val($(jsonres)[0].Address);
                $("#txtPinCode").val($(jsonres)[0].PinCode);
                $("#txtWebAddress").val($(jsonres)[0].Website);
                $("#txtPrice").val($(jsonres)[0].MealPrice);
                $('#txtCuisine').multiselect('refresh');
                if ($(jsonres)[0].Cuisine !== "" && $(jsonres)[0].Cuisine !== null && $(jsonres)[0].Cuisine !== undefined) {
                    var tmpArr = $(jsonres)[0].Cuisine.split(",");
                    console.log(tmpArr);
                    $('#txtCuisine').multiselect('select', tmpArr);
                }
                //else {
                //    $('#txtCuisine').multiselect('select', []);
                //}
                $("#txtContactNo").val($(jsonres)[0].ContactNumber);
                $(".payment").each(function (i, ele) {
                    $(ele).removeAttr("checked");
                });
                geocode();
                if ($(jsonres)[0].Payment !== null && $(jsonres)[0].Payment !== "" && $(jsonres)[0].Payment !== undefined) {
                    var payments = $(jsonres)[0].Payment.split(",");
                    $(".payment").each(function (i, ele) {
                        $.each(payments, function (i, ele1) {
                            if (ele1 === $(ele).val()) {
                                $(ele).prop('checked', true);
                            }
                        });
                    });
                }
            }
        },
        error: function (e) {
        }
    });
}
function backRestaurants() {
    $('#frmEdit')[0].reset();
    $("#divForm").fadeOut();
    $("#divGrid").fadeIn();
    menus = [];
    otherpics = [];
    defaultpics = [];
    docs = [];
    Dropzone.forElement("#fileMenus").removeAllFiles(true);
    Dropzone.forElement("#fileDefaultPics").removeAllFiles(true);
    Dropzone.forElement("#fileOtherPics").removeAllFiles(true);
    Dropzone.forElement("#fileDocs").removeAllFiles(true);
}
function fndelete(id) {
    if (confirm("Are you sure ?")) {
        $.ajax({
            url: "Resturent.aspx/RestaurantsDelete",
            data: JSON.stringify({ id: id }),
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (res) {
                if (res != null && res.d != null && res.d != undefined) {
                    getRestaurants();
                }
            },
            error: function (e) {
            }
        });
    }
}
function getCityByStateId(ele) {
    var obj = {
        stateid: ele.val()
    }
    $.ajax({
        url: "Resturent.aspx/getCityByState",
        data: JSON.stringify(obj),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var cityDrop = $('#txtCityEdit');
                cityDrop.empty();
                $.each(jsonres, function (i, ele) {
                    cityDrop.append($("<option></option>").val(ele.id).html(ele.name));
                });
            }
        }
    });
}
function getStates() {
    $.ajax({
        url: "Resturent.aspx/getState",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var stateDrop = $('#txtState');
                stateDrop.empty();
                $.each(jsonres, function (i, ele) {
                    stateDrop.append($("<option></option>").val(ele.id).html(ele.name));
                });
            }
        }
    });
}
function getCity() {
    $.ajax({
        url: "Resturent.aspx/getCity",
        //data: Data,
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            if (res != null && res.d != null && res.d != undefined) {
                jsonres = JSON.parse(res.d);
                var $input = $('#txtCity');
                $input.typeahead({
                    source: jsonres,
                    autoSelect: false
                });
                $input.change(function () {
                    var current = $input.typeahead("getActive");
                    if (current) {
                        // Some item from your model is active!
                        if (current.name == $input.val()) {
                            // This means the exact match is found. Use toLowerCase() if you want case insensitive match.
                        } else {
                            // This means it is only a partial match, you can either add a new item 
                            // or take the active if you don't want new items
                            current.id = 0;
                        }
                    } else {
                        // Nothing is active so it is a new value (or maybe empty value)
                        current.id = 0;
                    }
                });
            }
        }
    });
}
function checkValidAddress() {
    var validAddress = true;
    if ($("#txtWebAddress").val() !== "") {
        var url = $("#txtWebAddress").val();
        var pattern = /^(http|https)?:\/\/[a-zA-Z0-9-\.]+\.[a-z]{2,4}/;

        if (pattern.test(url)) {
        }
        else {
            validAddress = false;
        }
    }
    return validAddress;
}

function checkValid() {
    var valid = true;
    if ($("#txtPinCode").val() !== "") {
        if ($.isNumeric($("#txtPinCode").val())) {
            $("#errPincode").fadeOut();
        }
        else {
            $("#errPincode").fadeIn();
            valid = false;
        }
    }
    if ($("#txtPrice").val() !== "") {
        if ($.isNumeric($("#txtPrice").val())) {
            $("#errPrice").fadeOut();
        }
        else {
            $("#errPrice").fadeIn();
            valid = false;
        }
    }
    if ($("#txtContactNo").val() !== "") {
        if ($.isNumeric($("#txtContactNo").val())) {
            $("#errContact").fadeOut();
        }
        else {
            $("#errContact").fadeIn();
            valid = false;
        }
    }
    if (checkValidAddress()) {
        $("#errWebsite").fadeOut();
    }
    else {
        $("#errWebsite").fadeIn();
        valid = false;
    }
    return valid;
}

function saveData() {
    if (checkValid()) {
        var formData = new FormData($('#frmEdit')[0]);
        formData.append("hdnId", $("#hdnId").val());
        formData.append("hdnUserId", $("#hdnUserId").val());
        if ($('input[name=rdReservation]:checked', '#frmEdit').val() == undefined) {
            formData.append("reservation", "");
        }
        else {
            formData.append("reservation", $('input[name=rdReservation]:checked', '#frmEdit').val());
        }
        var highlights = '';
        var selectedhigHlightsOptions = $('#restauHighlights option:selected');
        for (var i = 0; i < selectedhigHlightsOptions.length; i++) {
            highlights += selectedhigHlightsOptions[i].value + ",";
        }
        if (highlights !== '') {
            highlights = highlights.slice(0, -1)
        }
        var cuisines = '';
        var selectedcuisines = $('#txtCuisine option:selected');
        for (var i = 0; i < selectedcuisines.length; i++) {
            cuisines += selectedcuisines[i].value + ",";
        }
        if (cuisines !== '') {
            cuisines = cuisines.slice(0, -1)
        }
        var payment = '';
        $(".payment").each(function (i, ele) {
            if ($(ele).is(":checked")) {
                payment += $(ele).val() + ",";
            }
        });
        if (payment !== '') {
            payment = payment.slice(0, -1)
        }
        formData.append("highlights", highlights);
        formData.append("payment", payment);
        formData.append("txtCuisine", cuisines);
        $.each(menus, function (i, ele) {
            formData.append("filemenus" + i, ele);
        });

        $.each(defaultpics, function (i, ele) {
            formData.append("filedefaultpics" + i, ele);
        });

        $.each(otherpics, function (i, ele) {
            formData.append("fileotherpics" + i, ele);
        });

        $.each(docs, function (i, ele) {
            formData.append("filedocs" + i, ele);
        });

        $.ajax({
            type: 'post',
            url: 'FileUpload.ashx',
            data: formData,
            success: function (status) {
                getRestaurants();
                $('#frmEdit')[0].reset();
                $("#divForm").fadeOut();
                $("#divGrid").fadeIn();
                menus = [];
                otherpics = [];
                defaultpics = [];
                docs = [];
                Dropzone.forElement("#fileMenus").removeAllFiles(true);
                Dropzone.forElement("#fileDefaultPics").removeAllFiles(true);
                Dropzone.forElement("#fileOtherPics").removeAllFiles(true);
                Dropzone.forElement("#fileDocs").removeAllFiles(true);
            },
            processData: false,
            contentType: false,
            error: function () {
                alert("Whoops something went wrong!");
            }
        });
    }
}

//DropzoneJS snippet - js

$(function () {

    Dropzone.autoDiscover = false;
    // instantiate the uploader
    $('#fileMenus').dropzone({
        url: "#",
        addRemoveLinks: true,
        maxFilesize: 100,
        paramName: "uploadfile",
        maxThumbnailFilesize: 5,
        init: function () {
            this.on('addedfile', function (file) {
                menus.push(file);
            });
            this.on("removedfile", function (file) {
                menus = jQuery.grep(menus, function (value) {
                    return value != file;
                });
            });
        }
    });

    $('#fileDefaultPics').dropzone({
        url: "#",
        maxFilesize: 100,
        paramName: "uploadfile",
        maxThumbnailFilesize: 5,
        init: function () {
            this.on('addedfile', function (file) {
                defaultpics.push(file);
            });
            this.on("removedfile", function (file) {
                defaultpics = jQuery.grep(defaultpics, function (value) {
                    return value != file;
                });
            });
        }
    });

    $('#fileOtherPics').dropzone({
        url: "#",
        maxFilesize: 100,
        paramName: "uploadfile",
        maxThumbnailFilesize: 5,
        init: function () {
            this.on('addedfile', function (file) {
                otherpics.push(file);
            });
            this.on("removedfile", function (file) {
                otherpics = jQuery.grep(otherpics, function (value) {
                    return value != file;
                });
            });
        }
    });

    $('#fileDocs').dropzone({
        url: "#",
        maxFilesize: 100,
        paramName: "uploadfile",
        maxThumbnailFilesize: 5,
        init: function () {
            this.on('addedfile', function (file) {
                docs.push(file);
            });
            this.on("removedfile", function (file) {
                docs = jQuery.grep(docs, function (value) {
                    return value != file;
                });
            });
        }
    });
});