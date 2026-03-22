public class HelloWorld {
    public static void main(String[] args) {
        String version = System.getProperty("java.version");
        String arch = System.getProperty("os.arch");
        String boldGreen = "\u001B[1;32m";
        String reset = "\u001B[0m";
        System.out.format("%sHello, Java runtime! (%s %s)%s%n", boldGreen, version, arch, reset);
    }
}

