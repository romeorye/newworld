package iris.web.common.util;

public class TableColumn
{

    protected TableColumn(int type, String name)
    {
        this.name = name;
        this.type = type;
    }

    protected int getType()
    {
        return type;
    }

    protected String getName()
    {
        return name;
    }

    private String name;
    private int type;
}
