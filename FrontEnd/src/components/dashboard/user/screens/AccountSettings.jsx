import React, { useState, useEffect } from 'react';
import { Tabs, Tab, Input, Button } from '@nextui-org/react';
import { updateUserInfo, changePass, fetchUserDetails } from '../../../../api/userApi';

export const AccountSettings = () => {
  const [selectedTab, setSelectedTab] = useState('account-info');
  const [userDataError, setUserDataError] = useState('');
  const [refresh, setRefresh] = useState(false);

  const [updateInfoSuccess, setUpdateInfoSuccess] = useState('');
  const [updateInfoError, setUpdateInfoError] = useState('');

  const [passwordChangeSuccess, setPasswordChangeSuccess] = useState('');
  const [passwordChangeError, setPasswordChangeError] = useState('');

  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');

  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmNewPassword, setConfirmNewPassword] = useState('');

  useEffect(() => {
    const handleUserData = async () => {
      try {
        const userInfo = await fetchUserDetails();
        setFirstName(userInfo.FirstName || '');
        setLastName(userInfo.LastName || '');
        setEmail(userInfo.Email || '');
        setPhone(userInfo.Phone || '');
      } catch (error) {
        setUserDataError('An error occurred while fetching user details.');
      }
    };

    handleUserData();
  }, [refresh]);

  // Handle updating user info
  const handleUpdateInfo = async () => {
    try {
      const response = await updateUserInfo(firstName, lastName, phone, email);
      setUpdateInfoSuccess('User information updated successfully.');
      setUpdateInfoError('');
      setRefresh(!refresh);
    } catch (error) {
      setUpdateInfoSuccess('');
      setUpdateInfoError('Error updating user info.');
    }
  };

  const handleChangePassword = async () => {
    try {
      const response = await changePass(currentPassword, newPassword, confirmNewPassword);
      setPasswordChangeSuccess('Password changed successfully.');
      setPasswordChangeError('');
    } catch (error) {
      setPasswordChangeSuccess('');
      setPasswordChangeError('The password you entered is incorrect.');
    }
  };

  const handleTabChange = (key) => {
    setSelectedTab(key);
  };

  return (
    <div className='flex flex-1 h-full'>
      <div className='p-2 md:p-10 rounded-tl-2xl border border-neutral-200 dark:border-neutral-700 bg-white dark:bg-neutral-900 flex flex-col gap-2 flex-1 w-full h-full'>
        <div className='flex w-full flex-col'>
          <Tabs variant='bordered' className='justify-center mb-6' selectedKey={selectedTab} onSelectionChange={handleTabChange}>
            <Tab title='Account Info' key='account-info'>
              <div className='flex flex-col gap-6 w-full max-w-4xl mx-auto'>
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  label='First Name'
                  placeholder='First Name'
                  type='text'
                  value={firstName}
                  onChange={(e) => setFirstName(e.target.value)}
                />
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  label='Last Name'
                  placeholder='Last Name'
                  type='text'
                  value={lastName}
                  onChange={(e) => setLastName(e.target.value)}
                />
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  label='Email'
                  placeholder='Email'
                  type='email'
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                />
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  label='Phone Number'
                  placeholder='Phone Number'
                  type='tel'
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                />
                <Button color='primary' className='w-32 self-center' onClick={handleUpdateInfo}>
                  Submit
                </Button>
                {updateInfoSuccess && <p className='text-green-600 text-center'>{updateInfoSuccess}</p>}
                {updateInfoError && <p className='text-red-600 text-center'>{updateInfoError}</p>}
              </div>
            </Tab>

            <Tab title='Change Password' key='change-password'>
              <div className='flex flex-col gap-6 w-full max-w-4xl mx-auto'>
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  type='password'
                  placeholder='Current Password'
                  value={currentPassword}
                  onChange={(e) => setCurrentPassword(e.target.value)}
                />
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  type='password'
                  placeholder='New Password'
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                />
                <Input
                  variant='bordered'
                  labelPlacement='outside'
                  type='password'
                  placeholder='Confirm New Password'
                  value={confirmNewPassword}
                  onChange={(e) => setConfirmNewPassword(e.target.value)}
                />
                <Button color='primary' className='w-32 self-center' onClick={handleChangePassword}>
                  Submit
                </Button>
                {passwordChangeSuccess && <p className='text-green-600 text-center'>{passwordChangeSuccess}</p>}
                {passwordChangeError && <p className='text-red-600 text-center'>{passwordChangeError}</p>}
              </div>
            </Tab>
          </Tabs>
        </div>
      </div>
    </div>
  );
};
