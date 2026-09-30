public class ContactOperations {
    public static Contact setDefaultDescription(Contact c) {
        // Changed description to trigger conflict
        c.Description = 'Updated1 description for US5';
        return c;
    }
}