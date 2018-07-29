%                      The Graphic User Object Toolbox            version 2.08
%                      ===============================
% 
% The graphicuserobject (GUO) class supports the grouping of uicontrol and axes
% objects ("child objects") as well as other graphicuserobjects ("child GUOs")
% into a composite object which can itself be placed on figures or as a child
% GUO in other graphicuserobjects.  This is a powerful tool for structuring and
% reusing elements of user interfaces together with their associated 
% functionality.  The graphicuserobject class provides a frame of reference
% together with maintenance, access and display functions for its child objects
% and GUOs.  The complete GUO with all its children can be positioned or
% resized easily, hidden and re-shown.  GUOdemo.m demonstrates the main 
% features of the graphicuserobject class;  detailed descriptions of the 
% functions are provided below and in their header comments.
% 
% The graphicuserobject constructor method creates a GUO.  Internally, an axes
% object (referred to as the GUO frame) is used to define the position of the
% graphicuserobject and to provide a frame of reference for its children.  The
% GUO frame, which is NOT a child object, is automatically provided with a
% unique Tag and its properties can be set either on creation or later (using
% the "set" method).
% 
% The child objects are created with the overloaded uicontrol or axes functions.
% They have the same parent figure as the graphicuserobject but are positioned
% relative to the graphicuserobject rather than relative to the parent figure.
% Furthermore, child objects whose Units are 'normalized' are also sized
% relative to the graphicuserobject.  Class methods are provided for accessing
% the child objects, which may be identified either by name or number (see 
% "uicontrol").
% 
% Direct access via the handles of the child objects should be avoided wherever
% possible because the integrity of the graphicuserobject can be compromised
% when properties such as Parent, Position or Units are set directly.  However,
% the only case where such direct access has been found necessary is when the
% callback function of a child object requires access to other child objects,
% and then only if the graphicuserobject itself is not available for assignment
% (see "setuserdata"), otherwise the methods listed below should be sufficient.
% Furthermore, handles of objects below axes in the object hierarchy (Image,
% Light, Line, Patch, Rectangle, Surface and Text objects) may be used freely,
% because these objects already have an axes object as their natural frame of
% reference.
% 
% An existing GUO instance can be made a child of another existing GUO by means
% of the "addchildguo" method, after which the child GUO exists within the
% properties of the parent GUO and is no longer directly assigned to.  Child
% GUOs are positioned/sized relative to their parent GUO in the same way as
% child objects are;  they may also be identified either by name or number
% (child GUOs are numbered separately from child objects - see "addchildguo").
% Methods of a child GUO may be executed by means of the "guoeval" method.
% 
% The following methods are available for the graphicuserobject class:
% 
% function GUO = graphicuserobject(varargin)
% Class constructor for graphicuserobject.  The argument list "varargin", if
% supplied, is passed on to the axes function when creating the GUO frame.  In
% particular, the Position property would normally be supplied and, for
% example, Visible can be specified as 'on' in order to provide a border for
% the GUO.
% 
% function GUO = uicontrol(GUO, varargin)
% Creates a child control within "GUO".  The argument list "varargin" is as for
% the standard MATLAB uicontrol function except that "GUO" is supplied instead
% of "parent".  Child controls are positioned relative to the GUO frame, and
% sized relative to the GUO frame if the Units property of the control is
% 'normalized' (the default here), in which case the control is set (internally)
% to the GUO frame's units.  Specifying the Tag property for the child control
% allows it to be referenced by name;  child controls (and child axes) may also
% be referenced by number (in order of their creation, starting with 1).
% 
% function GUO = axes(GUO, varargin)
% Creates or makes current a child axes object within "GUO".  To create a child
% axes object, the argument list "varargin" is as for the standard MATLAB axes
% function (i.e. property name/value pairs);  positioning and referencing is
% performed as described in "uicontrol".  To make an axes object (either a
% child or the GUO frame) the current axes, "varargin" must have exactly one
% element referencing the axes by name or number;  to make the GUO frame the
% current axes, the element may be supplied as empty, zero or the Tag of the
% GUO frame.
% 
% function GUO = addchildguo(GUO, ChildGUO)
% Inserts "ChildGUO" within "GUO", whereby both "ChildGUO" and "GUO" are 
% graphicuserobjects.  Child GUOs are positioned relative to the GUO frame of 
% their parent, and sized relative to this GUO frame if the Units property of
% the child GUO is 'normalized' (the default here).  Specifying the Tag property
% for the child GUO allows it to be referenced by name;  child GUOs may also be
% referenced by number (in order of their creation, starting with 1).  Child 
% GUOs are numbered separately from child objects (uicontrols and axes).
% 
% function display(GUO)
% Lists number, style and tag for the GUO frame, child GUOs and child objects
% of "GUO" in the MATLAB command window;  this method is executed by MATLAB
% when the GUO name is typed without a semicolon.
% 
% function val = get(GUO, varargin)
% Gets GUO frame (axes) properties of "GUO".  The "val" and "varargin" arguments
% are as for the standard MATLAB "get" function.
% 
% function val = set(GUO, varargin)
% Sets properties for the GUO frame of "GUO" (in which case the modified GUO is
% returned as "val") or returns information as for the standard MATLAB "set"
% function.  Property changes which affect the children of "GUO" are taken into
% consideration (e.g. Parent, Position and Units).
% 
% function GUO = delete(GUO)
% Deletes the GUO frame, child objects and child GUOs of "GUO".
% 
% function val = getuserdata(DummyGUO, Tag)
% Gets the UserData property from the GUO frame object identified by "Tag"
% (for use in callback functions - see also "setuserdata").  "DummyGUO" is 
% ignored - it is required by MATLAB in order to be able to find this method.
% 
% function setuserdata(DummyGUO, Tag, UserData)
% Sets the UserData property for the GUO frame object identified by "Tag".
% "DummyGUO" is ignored - it is required by MATLAB in order to be able to find
% this method.
% 
% The "getuserdata" and "setuserdata" methods allow callback functions in
% particular to access data associated with a GUO.  Although this is a
% fundamental breach of the object-oriented paradigm, the only alternative
% in MATLAB would be to define all such GUOs globally in order that they may be
% assigned to;  however, this would also be a breach of the paradigm and would
% be inappropriate in particular for general-purpose, reusable GUOs.  For an
% excellent definition of the object-oriented paradigm, see "Object-oriented
% Software Construction" by Bertrand Meyer (Prentice Hall).
% 
% function var = getchild(GUO, Child, varargin)
% Gets properties of GUO child object;  "Child" may be a Tag name or the number
% of the child object (see "uicontrol").
% 
% function valOrGUO = setchild(GUO, Child, varargin)
% Sets properties for GUO child object;  "Child" may be a Tag name or the number
% of the child object (see "uicontrol").  The return value valOrGUO must be
% assigned to the GUO in all cases except where the MATLAB set function would
% return a result (property information - see MATLAB help).
% 
% function GUO = deletechild(GUO, Child)
% Deletes GUO child object;  "Child" may be a Tag name or the number of the 
% child object (see "uicontrol").
% 
% function [nObjects, nGUOs] = nchildren(GUO)
% Returns the number of children within "GUO".
% "nObjects" is the number of child objects (uicontrols and axes) and "nGUOs" 
% is the number of child GUOs within "GUO".
% 
% function h = childhandles(GUO)
% Returns the handles of the children (uicontrols and axes) within "GUO". This
% method should only be used when absolutely necessary, because the integrity
% of a graphicuserobject can be compromised when child object properties such
% as Parent, Position or Units are set via handles.  Such properties should 
% only be set via the "setchild" method.
% 
% function GUO = deletechildguo(GUO, ChildGUO)
% Deletes "ChildGUO" from "GUO".
% "ChildGUO" may be a Tag name or a child GUO number (see "addchildguo").
% 
% function [GUO, ExpressionResult] = guoeval(GUO, ChildGUO, Expression)
% Evaluates expression for a child GUO within "GUO".
% "ChildGUO" may be a Tag name or a child GUO number (see "addchildguo").
% "Expression" is a string containing the function to be evaluated, the first 
% argument of which (the child GUO) must be omitted - this will be inserted
% automatically.  If the result is a GUO, it replaces the child GUO within 
% "GUO", otherwise it is returned as "ExpressionResult".
% "GUO" is always returned, whether changed or not.
% 
% function [GUO, WasHidden] = hide(GUO)
% Makes "GUO" invisible.  The Visible property is set to 'off' for the GUO
% frame (axes) and the children (uicontrols and axes) of "GUO", as well as for
% all children (e.g. text and rectangle objects) of the various axes.  The
% previous status of the Visible property for each of these objects is saved
% so that it can be restored by the "show" function.  The "hide" function
% applies itself recursively to the child GUOs. 
% "WasHidden" indicates whether "GUO" was already hidden.
% 
% function [GUO, WasHidden] = show(GUO)
% Makes "GUO" (if previously hidden) visible again.  The Visible property is
% set to its previous value for all objects affected by the "hide" function. 
% "WasHidden" indicates whether "GUO" was already hidden.
% 
% function GUO = resizefcn(GUO)
% Corrects the position of children and child GUOs of "GUO" after the parent
% figure is resized.  However, most cases are handled automatically:  it is 
% only necessary to call this function (from the figure's ResizeFcn) if "GUO"
% has Units 'normalized' and contains one or more children or child GUOs having
% Units other than 'normalized' (e.g. 'pixels').
%
% function h = figure(GUO)
% Makes the parent figure of "GUO" the current figure and returns its handle.
%
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production
