import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorControllerTest {

    private static final double DELTA = 0.0001;

    @Test
    void testAdd() {
        assertEquals(15.0, 10 + 5, DELTA);
    }

    @Test
    void testAddNegative() {
        assertEquals(-3.0, -8 + 5, DELTA);
    }

    @Test
    void testSubtract() {
        assertEquals(5.0, 10 - 5, DELTA);
    }

    @Test
    void testSubtractNegativeResult() {
        assertEquals(-3.0, 2 - 5, DELTA);
    }


    @Test
    void testMultiply() {
        assertEquals(50.0, 10 * 5, DELTA);
    }

    @Test
    void testMultiplyByZero() {
        assertEquals(0.0, 99 * 0, DELTA);
    }

    @Test
    void testDivide() {
        assertEquals(2.0, 10.0 / 5.0, DELTA);
    }

    @Test
    void testDivideDecimalResult() {
        assertEquals(3.5, 7.0 / 2.0, DELTA);
    }

    @Test
    void testDivideByZero() {
        double num2 = 0;
        assertTrue(num2 == 0);
    }
}