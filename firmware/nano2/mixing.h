#include <stdint.h>
#include <stdbool.h>

#define WEAPON_MODE_DEFAULT 0
#define WEAPON_MODE_FLIPHARD 1

// tells us that this weapon pad is connected to a servo
// permits servo-specific functionality such as servo doubling (enable_servo_double must still be on)
#define PWM_WEAPON_MODE_SERVO 0

// tells us that this weapon pad is connected to a BLDC ESC
// permits brushless weapon functionality such as deadzone
#define PWM_WEAPON_MODE_BLDC_ESC 1 

// deadzones to apply
// deadzone values for weapons
#define DC_WEAPON_DEADZONE 20
#define THROTTLE_DEADZONE 10
#define STEERING_DEADZONE 10
// note: BLDC ESC pulse range for a weapon is 500, so for 5% want 25
#define BLDC_WEAPON_DEADZONE 25

typedef struct {
    uint8_t weapon_mode;
    bool invert_left;
    bool invert_right;
    bool invert_weapon;
    bool enable_mixing;
    bool swap_weapon_channels; 
    bool enable_braking;
// Flag: enable "servo double" logic which expands the range of
// some servos by sending longer and shorter pulses.
    bool enable_servo_double;
// Flag: enable 100% steering mix. Useful for some robots / transmitters.
    bool enable_max_steering;
    uint8_t reserved[20]; // Reserve 20 bytes to retain compatibility with possible future malenki settings
    uint8_t weapon2_mode; // one of PWM_WEAPON_MODE constants
    uint8_t weapon3_mode; // one of PWM_WEAPON_MODE constants

}  mixing_state_t;

extern mixing_state_t mixing_state;

void mixing_init();
void mixing_init_custom();
void mixing_drive_motors(int16_t throttle, int16_t steering, int16_t weapon, bool invert);
int deadzone(int n, int deadzone);