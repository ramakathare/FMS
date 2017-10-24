<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.user>" %>

<h2>HelloPartial <%if (Model != null) Writer.Write(Model.name);%></h2>