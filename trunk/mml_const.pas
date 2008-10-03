unit mml_const;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�T�N���ŗp����萔���`�������j�b�g
s
���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}

interface

uses
  Windows,
  SysUtils,
  Classes;

const
    ENZANSI_CHAR     = ['+','-','*','/','%','<','>','=','|','&','^','!'];      //�� '^' �́A�^�C�L���Ȃ̂Œ���
    ENZANSI_NEXT_CHAR = ['<','>','=','|','&','!'];
    ARG_CHAR         = ['=','(','$','0'..'9','!','{'];
    USER_DEFINE_CHAR = ['!','%','(',')','\','/','=','*','?'];  //���[�U�[����`�ł���L��

    BOOL_TRUE = 1; // ��{�I�ɁA0 �ȊO�́ATRUE�ƌ��Ȃ�
    BOOL_FALSE = 0;

    VAR_TYPE_INT = 'i';
    VAR_TYPE_STR = 's';
    VAR_TYPE_ARRAY= 'a';

    //���艹���̔ԍ�
    SOUND_TYPE_GM = 0;
    SOUND_TYPE_GS = 1;
    SOUND_TYPE_XG = 2;

    //WAVE_TYPE ��s�w���
    WAVE_TYPE_LINE = 0;
    WAVE_TYPE_SINE = 1;

    // Note No TABLE
    //  9 11  0  2  4  5  7
    //  a  b  c  d  e  f  g
    NOTE_NO_TABLE: array [0..6] of Integer = (9,11,0,2,4,5,7);

    //��s�w��̃R�}���h��
    {��s�w��}
    OPTION_ON_NOTE   = 'onNote'; //(����).onNote(v1,v2,v3...)//�m�[�g�I�����̒l�̐�s�w��
    OPTION_ON_NOTE2  = 'N';//(����).N(v1,v2,v3...)//�m�[�g�I�����̒l�̐�s�w��
    OPTION_ON_TIME   = 'onTime';//(����).onTime(low,high,len...)//�w�莞�Ԗ��̒l�̐��ړI��s�w��B
    OPTION_ON_TIME2  = 'T';//(����).T(low,high,len, low,high,len...)//�w�莞�Ԗ��̒l�̐��ړI��s�w��
    OPTION_CC_SINE   = 'Sine';//(����).Sine(type,low,high,len,times)//�R���g���[���`�F���W�̘A���l�������ݖ���type=0:sine/1:up sine/2:down sine
    OPTION_ON_SINE   = 'onNoteSine';//(����).onNoteSine(type,low,high,len,times)//�m�[�g�I�����ɃR���g���[���`�F���W�̘A���l�������ݖ��� type=0:sine/1:up sine/2:down sine
    OPTION_ON_CYCLE  = 'onCycle';//(����).onCycle(len,v1,v2,v3...)//�w�莞�Ԗ��̒l�̐�s�w��
    OPTION_ON_CYCLE2 = 'C';//(����).C(len,v1,v2,v3...)//�w�莞�Ԗ��̒l�̐�s�w��
    OPTION_ON_WAVE   = 'onNoteWave';//(����).onNoteWave(low,high,len...)//�m�[�g�I�����ɒ����I�Ȓl�̐��ڂ���������(�R���g���[���`�F���W,�x���h)
    OPTION_ON_WAVE2  = 'W';//(����).W(low,high,len...)//�m�[�g�I�����ɒ����I�Ȓl�̐��ڂ���������(�R���g���[���`�F���W,�x���h)
    OPTION_ON_WAVE_EX= 'onNoteWaveEx';//(����).W(low,high,len...)//�m�[�g�I�����ɁA�m�[�g�̒����ɉ������g�`����������(�R���g���[���`�F���W,�x���h)
    OPTION_ON_WAVE_EX2= 'WE';//(����).W(low,high,len...)//�m�[�g�I�����ɁA�m�[�g�̒����ɉ������g�`����������(�R���g���[���`�F���W,�x���h)
    OPTION_ON_WAVE_R =  'onNoteWaveR';//(����).onNoteWaveR(low,high,len...)//�m�[�g�I�����Ă���ԁAlow,higi,len...���J��Ԃ�
    OPTION_ON_WAVE_R2=  'WR';//(����).WR(low,high,len...)//�m�[�g�I�����Ă���ԁAlow,higi,len...���J��Ԃ�
    OPTION_DELAY     = 'Delay';//(����).Delay=v//��s�w��̌��ʂ̒x������
    OPTION_REPEAT    = 'Repeat';//(����).Repeat(on/off)//�\��w���.onNote�ȂǂŌJ��Ԃ����ǂ���
    OPTION_RANDOM    = 'Random';//(����).Random=v//�������܂��l�ɁAv�̃����_���Ȓl�𑫂�
    OPTION_RANGE     = 'Range';//(����).Range(low,high)//�������܂��l�ɁA����Ɖ�����ݒ肷��
    OPTION_FREQUENCY = 'Frequency';//(����).WR(low,high,len...)//�R���g���[���`�F���W�̏������ݕp�x���w�肷��
    OPTION_MAX       = 'Max';//q.Max|v.Max//q��v�̍ő�l��ύX����
    {/��s�w��}

    //�^�C���[�h
    TIE_PORT         = 0;//�m�[�g�I�����A�|���^�����g�łȂ�
    TIE_BEND         = 1;//�m�[�g�I�����A�x���h�łȂ�
    TIE_GATE         = 2;//�m�[�g�I���̃Q�[�g��100%�ɂ���
    TIE_ALP          = 3;//�ǂ�ǂ�d�Ȃ�

    BEND_RANGE_MAX = 12;//�x���h�����W�̍ő�l�́A�P�Q�Ƃ���(GM���x��)

    //����R���g���[���`�F���W
    CC_NO_BEND      = 257;
    CC_NO_BEND_FULL = 256;

    //CC
    CC_NO_VOLUME     = 7;
    CC_NO_EXPRESSION = 11;
    CC_NO_PANPOT     = 10;
    CC_NO_REVERB     = 91;

implementation

end.
