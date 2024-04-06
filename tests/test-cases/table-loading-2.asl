// Name: Recursive table loads
// Expect: int => 0

DefinitionBlock ("", "DSDT", 2, "uTEST", "TESTTABL", 0xF0F0F0F0)
{
    // Number of started table loads
    Name (NUMB, 0)

    // Number of finished table loads
    Name (NUMA, 0)

    /*
     * DefinitionBlock ("", "SSDT", 1, "uTEST", "TESTTABL", 0xF0F0F0F0)
     * {
     *     External(NUMA, IntObj)
     *     External(NUMB, IntObj)
     *     External(ITEM, IntObj)
     *     External(TABL, IntObj)
     *
     *     // Recursively start 10 table loads
     *     If (NUMB < 10) {
     *         // Create an ITEM here to prove to the caller that we got invoked
     *         If (!CondRefOf(ITEM)) {
     *             Name (ITEM, 123)
     *         }
     *
     *         NUMB += 1
     *         Local0 = Load(TABL)
     *
     *         // The last load is expected to fail, everything before should succeed
     *         If (!Local0) {
     *             If (NUMB != 10) {
     *                 NUMA = 0xDEADBEEF
     *                 Printf("Table load %o failed", NUMB)
     *             }
     *         } Else {
     *             NUMA += 1
     *         }
     *
     *
     *         // Return something bogus here to make sure the return value isn't
     *         // propagated to the caller of Load.
     *         Return (Package { 1, 2 ,3})
     *     }
     *
     *     // We're the last table load, do something naughty to cause an error
     *     Local0 = Package { 1 }
     *     Local1 = RefOf(Local0)
     *
     *     // This code specifically attempts to perform a bogus implicit cast
     *     Local1 = "Hello World"
     * }
     */
    Name (TABL, Buffer {
        0x53, 0x53, 0x44, 0x54, 0xdc, 0x00, 0x00, 0x00,
        0x01, 0x33, 0x75, 0x54, 0x45, 0x53, 0x54, 0x00,
        0x54, 0x45, 0x53, 0x54, 0x54, 0x41, 0x42, 0x4c,
        0xf0, 0xf0, 0xf0, 0xf0, 0x49, 0x4e, 0x54, 0x4c,
        0x28, 0x06, 0x23, 0x20, 0xa0, 0x22, 0x00, 0x15,
        0x5c, 0x4e, 0x55, 0x4d, 0x41, 0x01, 0x00, 0x15,
        0x5c, 0x4e, 0x55, 0x4d, 0x42, 0x01, 0x00, 0x15,
        0x5c, 0x49, 0x54, 0x45, 0x4d, 0x01, 0x00, 0x15,
        0x5c, 0x54, 0x41, 0x42, 0x4c, 0x01, 0x00, 0xa0,
        0x4b, 0x07, 0x95, 0x4e, 0x55, 0x4d, 0x42, 0x0a,
        0x0a, 0xa0, 0x10, 0x92, 0x5b, 0x12, 0x49, 0x54,
        0x45, 0x4d, 0x00, 0x08, 0x49, 0x54, 0x45, 0x4d,
        0x0a, 0x7b, 0x72, 0x4e, 0x55, 0x4d, 0x42, 0x01,
        0x4e, 0x55, 0x4d, 0x42, 0x70, 0x5b, 0x20, 0x54,
        0x41, 0x42, 0x4c, 0x00, 0x60, 0xa0, 0x38, 0x92,
        0x60, 0xa0, 0x34, 0x92, 0x93, 0x4e, 0x55, 0x4d,
        0x42, 0x0a, 0x0a, 0x70, 0x0c, 0xef, 0xbe, 0xad,
        0xde, 0x4e, 0x55, 0x4d, 0x41, 0x70, 0x73, 0x73,
        0x0d, 0x54, 0x61, 0x62, 0x6c, 0x65, 0x20, 0x6c,
        0x6f, 0x61, 0x64, 0x20, 0x00, 0x4e, 0x55, 0x4d,
        0x42, 0x00, 0x0d, 0x20, 0x66, 0x61, 0x69, 0x6c,
        0x65, 0x64, 0x00, 0x00, 0x5b, 0x31, 0xa1, 0x0b,
        0x72, 0x4e, 0x55, 0x4d, 0x41, 0x01, 0x4e, 0x55,
        0x4d, 0x41, 0xa4, 0x12, 0x07, 0x03, 0x01, 0x0a,
        0x02, 0x0a, 0x03, 0x70, 0x12, 0x03, 0x01, 0x01,
        0x60, 0x70, 0x71, 0x60, 0x61, 0x70, 0x0d, 0x48,
        0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x57, 0x6f, 0x72,
        0x6c, 0x64, 0x00, 0x61
    })

    Method (MAIN, 0, Serialized)
    {
        Load(TABL, Local0)
        Printf("Recursive loads finished!")

        If (!Local0) {
            Printf("Table load failed!")
            Return (0xCAFEBABE)
        }

        External(ITEM, IntObj)
        If (ITEM != 123) {
            Printf("ITEM has incorrect value %o", ITEM)
            Return (0xDEADBEEF)
        }

        If (NUMB != 10) {
            Printf("Invalid NUMB value %o", ToDecimalString(NUMB))
            Return (0xEEFFAABB)
        }

        If (NUMA != 9) {
            Printf("Invalid NUMA value %o", ToDecimalString(NUMA))
            Return (0x11223344)
        }

        Return (0)
    }
}